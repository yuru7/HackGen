#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
PREFIX="$1"

FONT_PATTERN=${PREFIX}'HackGen[^3]*.ttf'
FONT35_PATTERN=${PREFIX}'HackGen35*.ttf'

CMAP_MASTER="${BASE_DIR}/source/cmap_format_14_master"
TMP_CMAP_MASTER='tmp_cmap_format_14_master'
TMP_TTX='tmp_cmap_format_14'
GENERATED_CMAP='gen_cmap'

function buildCmap() {
  ttx_path="$1"
  # cmapマスタの作成
  (
    awk 'NR > 1 {print}' "$CMAP_MASTER" | while read line
    do
      out_name=$(echo "$line" | awk -F, '{print $4}')
      grep_out_name=$(egrep -m1 "name=\"${out_name}[#\"]" "$ttx_path" | perl -pe 's/^.+name="([^"]+?)".+/$1/')
      if [ -z "$grep_out_name" ]; then
        continue
      fi
      echo "$line" | awk -F, '{print $1 "," $2 "," $3 "," "'$grep_out_name'"}'
    done
  ) > "$TMP_CMAP_MASTER"

  # 追加するcmapタグを一時ファイルに書き出し
  awk -F, '
    BEGIN {print "<cmap_format_14 platformID=\"0\" platEncID=\"5\">"}
    NR > 1 && $4 != "" {print "<map uv=\"" $1 "\" uvs=\"" $3 "\" name=\"" $4 "\"/>"}
    END {print "</cmap_format_14></cmap>"}
  ' "$TMP_CMAP_MASTER" > "$TMP_TTX"

  # 適用するttxファイルを作成
  (
    egrep -v 'cmap_format_14| uvs=' "$ttx_path" | awk '/<\/cmap>/ {exit} {print}'
    cat "$TMP_TTX"
    awk 'BEGIN {prFlag = 0} /<post>/ {prFlag = 1} prFlag == 1 {print}' "$ttx_path"
  ) > $GENERATED_CMAP
}

function proc() {
  font="$1"

  if [ ! -f "$font" ]; then
    echo "File not found: $font"
    return
  fi

  ttx -t cmap -t post $font
  mv ${font} ${font}_orig
  buildCmap "${font%%.ttf}.ttx"
  ttx -o ${font} -m ${font}_orig $GENERATED_CMAP
}

echo '### Start cmap_patch ###'

font_list=$(ls ${BASE_DIR}/${FONT_PATTERN} ${BASE_DIR}/${FONT35_PATTERN})

for f in $font_list; do
  echo "Start cmap_patch: $f"
  (
    # 並列処理時に競合しないように各ファイル名に接頭辞を付ける（これら変数の変更はこのサブシェル下でのみ有効）
    file_suffix="_$(basename "${f%%.ttf}")"
    TMP_CMAP_MASTER+=$file_suffix
    TMP_TTX+=$file_suffix
    GENERATED_CMAP+=$file_suffix

    proc "$f"

  ) > "${f}.cmap_patch_output" 2>&1 &
done

wait

# 並列処理からの出力内容をまとめて出力
for f in $font_list; do
  output_filename="${f}.cmap_patch_output"
  echo "$output_filename" | sed -r "s/(.+)\.cmap_patch_output/# cmap_patch output: \1/"
  cat "$output_filename"
  rm "$output_filename"
done

rm -f "$GENERATED_CMAP"_* "$TMP_CMAP_MASTER"_* "$TMP_TTX"_* *.ttx *.ttf_orig
