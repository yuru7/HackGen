#!/bin/sh

base_dir=$(cd $(dirname $0); pwd)
# HackGen Generator
hackgen_version="$2"

# Set familyname
familyname_preffix="$1"
hackgen_familyname=${familyname_preffix}"HackGen"
hackgen_familyname_suffix=""
hackgen35_familyname=${hackgen_familyname}"35"
hackgen35_familyname_suffix=""
hackgen_console_suffix="Console"
hackgen_nerd_suffix="NF"
hackgen_nerd_jp_suffix="NFJ"
hackgen_evacuation_nerd_familyname="Evacuation${hackgen_familyname}Nerd"
hackgen35_evacuation_nerd_familyname="Evacuation${hackgen35_familyname}Nerd"
hackgen_evacuation_symbol_familyname=${hackgen_familyname}"EvacuationSymbol"
hackgen35_evacuation_symbol_familyname=${hackgen35_familyname}"EvacuationSymbol"
hackgen_box_drawing_light_familyname=${hackgen_familyname}"BoxDrawingLight"
hackgen35_box_drawing_light_familyname=${hackgen35_familyname}"BoxDrawingLight"

copyright='###COPYRIGHT###'

# Set ascent and descent (line width parameters)
hackgen_ascent=938
hackgen_descent=210
hackgen35_ascent=951
hackgen35_descent=243

em_ascent=881
em_descent=143
em=$(($em_ascent + $em_descent))

typo_line_gap=80

hack_width=616
genjyuu_width=1024

hackgen_half_width=540
hackgen_full_width=$((${hackgen_half_width} * 2))
hack_shrink_x=88
hack_shrink_y=93

hackgen35_half_width=618
hackgen35_full_width=$((${hackgen35_half_width} * 5 / 3))

# Set path to fontforge command
fontforge_command="fontforge"
ttfautohint_command="ttfautohint"

# Set redirection of stderr
redirection_stderr="/dev/null"

# Set fonts directories used in auto flag
fonts_directories="${base_dir}/source/"

# Set zenkaku space glyph
zenkaku_space_glyph=""

# Set flags
leaving_tmp_flag="false"
fullwidth_ambiguous_flag="true"
scaling_down_flag="true"

# Set non-Discorded characters
non_discorded_characters=""

# Set filenames
hack_regular_src="Hack-Regular.ttf"
hack_bold_src="Hack-Bold.ttf"
mod_arrow_regular_src="modify_arrow_Hack-Regular.sfd"
mod_arrow_bold_src="modify_arrow_Hack-Bold.sfd"
nerd_patched_hack_regular_src="Hack Regular Nerd Font Complete.ttf"
nerd_patched_hack_bold_src="Hack Bold Nerd Font Complete.ttf"
genjyuu_regular_src="GenJyuuGothicL-Monospace-Regular.ttf"
genjyuu_bold_src="GenJyuuGothicL-Monospace-Bold.ttf"

fix_genjyuu_bold_src="fix_GenJyuuGothicL-Monospace-Bold.sfd"

modified_hack_material_generator="modified_hack_material_generator.pe"
modified_hack_material_regular="Modified-Hack-Material-Regular.sfd"
modified_hack_material_bold="Modified-Hack-Material-Bold.sfd"

modified_hack_powerline_generator="modified_hack_powerline_generator.pe"
modified_hack_powerline_regular="Modified-Hack-Powerline-Regular.sfd"
modified_hack_powerline_bold="Modified-Hack-Powerline-Bold.sfd"

modified_hack35_powerline_generator="modified_hack35_powerline_generator.pe"
modified_hack35_powerline_regular="Modified-Hack35-Powerline-Regular.sfd"
modified_hack35_powerline_bold="Modified-Hack35-Powerline-Bold.sfd"

modified_hack_box_drawing_light_generator="modified_hack_box_drawing_light_generator.pe"
modified_hack_box_drawing_light_regular="Modified-Hack-box_drawing_light-Regular.sfd"
modified_hack_box_drawing_light_bold="Modified-Hack-box_drawing_light-Bold.sfd"

modified_hack35_box_drawing_light_generator="modified_hack35_box_drawing_light_generator.pe"
modified_hack35_box_drawing_light_regular="Modified-Hack35-box_drawing_light-Regular.sfd"
modified_hack35_box_drawing_light_bold="Modified-Hack35-box_drawing_light-Bold.sfd"

modified_hack_evacuate_from_hinting_generator="modified_hack_evacuate_from_hinting_generator.pe"
modified_hack_evacuate_from_hinting_regular="Modified-Hack-Evacuate_From_Hinting-Regular.sfd"
modified_hack_evacuate_from_hinting_bold="Modified-Hack-Evacuate_From_Hinting-Bold.sfd"

modified_hack35_evacuate_from_hinting_generator="modified_hack35_evacuate_from_hinting_generator.pe"
modified_hack35_evacuate_from_hinting_regular="Modified-Hack35-Evacuate_From_Hinting-Regular.sfd"
modified_hack35_evacuate_from_hinting_bold="Modified-Hack35-Evacuate_From_Hinting-Bold.sfd"

modified_hack_console_generator="modified_hack_console_generator.pe"
modified_hack_console_regular="Modified-Hack-Console-Regular.sfd"
modified_hack_console_bold="Modified-Hack-Console-Bold.sfd"

modified_hack35_console_generator="modified_hack35_console_generator.pe"
modified_hack35_console_regular="Modified-Hack35-Console-Regular.sfd"
modified_hack35_console_bold="Modified-Hack35-Console-Bold.sfd"

modified_hack_generator="modified_hack_generator.pe"
modified_hack_regular="Modified-Hack-Regular.sfd"
modified_hack_bold="Modified-Hack-Bold.sfd"

modified_hack35_generator="modified_hack35_generator.pe"
modified_hack35_regular="Modified-Hack35-Regular.sfd"
modified_hack35_bold="Modified-Hack35-Bold.sfd"

modified_genjyuu_generator="modified_genjyuu_generator.pe"
modified_genjyuu_regular="Modified-GenJyuuGothicL-Monospace-regular.sfd"
modified_genjyuu_bold="Modified-GenJyuuGothicL-Monospace-bold.sfd"

modified_genjyuu35_generator="modified_genjyuu35_generator.pe"
modified_genjyuu35_regular="Modified-GenJyuuGothicL35-Monospace-regular.sfd"
modified_genjyuu35_bold="Modified-GenJyuuGothicL35-Monospace-bold.sfd"

modified_genjyuu_console_generator="modified_genjyuu_console_generator.pe"
modified_genjyuu_console_regular="Modified-GenJyuuGothicL-Monospace-regular_console.sfd"
modified_genjyuu_console_bold="Modified-GenJyuuGothicL-Monospace-bold_console.sfd"

modified_genjyuu35_console_generator="modified_genjyuu35_console_generator.pe"
modified_genjyuu35_console_regular="Modified-GenJyuuGothicL35-Monospace-regular_console.sfd"
modified_genjyuu35_console_bold="Modified-GenJyuuGothicL35-Monospace-bold_console.sfd"

modified_hackgen_nerd_console_symbol_generator="modified_hackgen_nerd_console_symbol_generator.pe"
modified_hackgen_nerd_console_symbol_regular="Modified-HackGen-Nerd-Console-Symbol-Regular.sfd"
modified_hackgen_nerd_console_symbol_bold="Modified-HackGen-Nerd-Console-Symbol-Bold.sfd"

modified_hackgen35_nerd_console_symbol_generator="modified_hackgen35_nerd_console_symbol_generator.pe"
modified_hackgen35_nerd_console_symbol_regular="Modified-HackGen35-Nerd-Console-Symbol-Regular.sfd"
modified_hackgen35_nerd_console_symbol_bold="Modified-HackGen35-Nerd-Console-Symbol-Bold.sfd"

hackgen_generator="hackgen_generator.pe"
hackgen_console_generator="hackgen_console_generator.pe"
hackgen_evacuate_from_hinting_generator="hackgen_evacuate_from_hinting_generator.pe"
hackgen_box_drawing_light_generator="hackgen_box_drawing_light_generator.pe"
hackgen_nerd_console_symbol_generator="hackgen_nerd_console_symbol_generator.pe"

hackgen35_generator="hackgen35_generator.pe"
hackgen35_console_generator="hackgen35_console_generator.pe"
hackgen35_evacuate_from_hinting_generator="hackgen35_evacuate_from_hinting_generator.pe"
hackgen35_box_drawing_light_generator="hackgen35_box_drawing_light_generator.pe"
hackgen35_nerd_console_symbol_generator="hackgen35_nerd_console_symbol_generator.pe"

# Get input fonts
tmp=""
for i in $fonts_directories
do
    [ -d "${i}" ] && tmp="${tmp} ${i}"
done
fonts_directories="${tmp}"
# Search Hack
input_hack_regular=`find $fonts_directories -follow -name "$hack_regular_src" | head -n 1`
input_hack_bold=`find $fonts_directories -follow -name "$hack_bold_src" | head -n 1`
input_mod_arrow_regular=`find $fonts_directories -follow -name "$mod_arrow_regular_src" | head -n 1`
input_mod_arrow_bold=`find $fonts_directories -follow -name "$mod_arrow_bold_src" | head -n 1`

if [ -z "${input_hack_regular}" -o -z "${input_hack_bold}" ]
then
  echo "Error: $hack_regular_src and/or $hack_bold_src not found" >&2
  exit 1
fi
if [ -z "${input_mod_arrow_regular}" -o -z "${input_mod_arrow_bold}" ]
then
  echo "Error: $input_mod_arrow_regular and/or $input_mod_arrow_bold not found" >&2
  exit 1
fi

# Search GenJyuuGothicL
input_genjyuu_regular=`find $fonts_directories -follow -iname "$genjyuu_regular_src" | head -n 1`
input_genjyuu_bold=`find $fonts_directories -follow -iname "$genjyuu_bold_src"    | head -n 1`
if [ -z "${input_genjyuu_regular}" -o -z "${input_genjyuu_bold}" ]
then
  echo "Error: $genjyuu_regular_src and/or $genjyuu_bold_src not found" >&2
  exit 1
fi

input_fix_genjyuu_bold=`find $fonts_directories -follow -iname "$fix_genjyuu_bold_src" | head -n 1`

# Search improved legibility file
input_improved_legibility_regular=`find $fonts_directories -follow -iname improved_legibility-Regular.sfd | head -n 1`
input_improved_legibility_bold=`find $fonts_directories -follow -iname improved_legibility-Bold.sfd    | head -n 1`

# Search REIWA
input_reiwa_regular=`find $fonts_directories -follow -iname reiwa-Regular.sfd | head -n 1`
input_reiwa_bold=`find $fonts_directories -follow -iname reiwa-Bold.sfd    | head -n 1`

# Search Ideographic Space
input_ideographic_space=`find $fonts_directories -follow -iname Ideographic_Space.sfd | head -n 1`

# Search nerd patched hack
input_nerd_patched_hack_regular=`find $fonts_directories -follow -iname "$nerd_patched_hack_regular_src" | head -n 1`
input_nerd_patched_hack_bold=`find $fonts_directories -follow -iname "$nerd_patched_hack_bold_src"    | head -n 1`

# Check filename
[ "$(basename $input_hack_regular)" != "$hack_regular_src" ] &&
  echo "Warning: ${input_hack_regular} does not seem to be Hack Regular" >&2
[ "$(basename $input_hack_bold)" != "$hack_bold_src" ] &&
  echo "Warning: ${input_hack_regular} does not seem to be Hack Bold" >&2
[ "$(basename $input_genjyuu_regular)" != "$genjyuu_regular_src" ] &&
  echo "Warning: ${input_genjyuu_regular} does not seem to be GenJyuuGothicL Regular" >&2
[ "$(basename $input_genjyuu_bold)" != "$genjyuu_bold_src" ] &&
  echo "Warning: ${input_genjyuu_bold} does not seem to be GenJyuuGothicL Bold" >&2

# Check fontforge existance
if ! which $fontforge_command > /dev/null 2>&1
then
  echo "Error: ${fontforge_command} command not found" >&2
  exit 1
fi

# Make temporary directory
if [ -w "/tmp" -a "${leaving_tmp_flag}" = "false" ]
then
  tmpdir=`mktemp -d /tmp/hackgen_generator_tmpdir.XXXXXX` || exit 2
else
  tmpdir=`mktemp -d ./hackgen_generator_tmpdir.XXXXXX`    || exit 2
fi

# Remove temporary directory by trapping
if [ "${leaving_tmp_flag}" = "false" ]
then
  trap "if [ -d \"$tmpdir\" ]; then echo 'Remove temporary files'; rm -rf $tmpdir; echo 'Abnormally terminated'; fi; exit 3" HUP INT QUIT
  trap "if [ -d \"$tmpdir\" ]; then echo 'Remove temporary files'; rm -rf $tmpdir; echo 'Abnormally terminated'; fi" EXIT
else
  trap "echo 'Abnormally terminated'; exit 3" HUP INT QUIT
fi

# Powerline フォント (Hack に標準で含まれている)
powerline_symbols='
  SelectMore(0ue0a0, 0ue0a2)
  SelectMore(0ue0b0, 0ue0b3)
'

# 拡張版 Powerline フォント
powerline_extra_symbols='
  SelectMore(0ue0a3)
  SelectMore(0ue0b4, 0ue0c8)
  SelectMore(0ue0ca)
  SelectMore(0ue0cc, 0ue0d2)
  SelectMore(0ue0d4)
'

# Nerd Fonts から適用するグリフ
select_nerd_symbols="
  # IEC Power Symbols
  SelectMore(0u23fb, 0u23fe)
  SelectMore(0u2b58)

  # Octicons
  SelectMore(0u2665)
  SelectMore(0u26A1)
  SelectMore(0uf27c)
  SelectMore(0uf400, 0uf4a9)

  # Font Awesome Extension
  SelectMore(0ue200, 0ue2a9)

  # Weather
  SelectMore(0ue300, 0ue3e3)

  # Seti-UI + Custom
  SelectMore(0ue5fa, 0ue62e)

  # Devicons
  SelectMore(0ue700, 0ue7c5)

  # Font Awesome
  SelectMore(0uf000, 0uf2e0)

  # Font Logos (Formerly Font Linux)
  SelectMore(0uf300, 0uf31c)

  # Material Design Icons
  SelectMore(0uf500, 0ufd46)

  # Pomicons
  SelectMore(0ue000, 0ue00a)
"

# 罫線記号
box_drawing_light_symbols="
  SelectMore(0u2500, 0u259f)
"

# ヒンティング処理から除外するグリフ
select_evacuate_from_hinting="
  ${powerline_symbols}
"

# console 版と通常版の Hack から合成するグリフ差分
select_glyph_is_not_console="
  ${box_drawing_light_symbols}

  # 記号
  SelectMore(0u00a1, 0u00a5)
  SelectMore(0u00a7, 0u0522)
  SelectMore(0u0e3f)
  SelectMore(0u2010, 0u2021)
  SelectMore(0u2024, 0u2026)
  SelectMore(0u202f, 0u204b)
  SelectMore(0u2070, 0u208e)
  SelectMore(0u20a0, 0u20b9)
  SelectMore(0u2116, 0u215f)
  SelectMore(0u2200, 0u2215)
  SelectMore(0u221a, 0u222d)

  # 矢印
  SelectMore(0u2190, 0u2199)
  SelectMore(0u21a8)
  SelectMore(0u21b0, 0u21b5)
  SelectMore(0u21b8, 0u21b9)
  SelectMore(0u21c4, 0u21cc)
  SelectMore(0u21d0, 0u21d9)
  SelectMore(0u21e4, 0u21ed)
  SelectMore(0u21f5)
  SelectMore(0u27a1)
  SelectMore(0u2b05, 0u2b07)

  # 数学記号
  SelectMore(0u2234, 0u2237)
  SelectMore(0u223c, 0u223d)
  SelectMore(0u2242, 0u2243)
  SelectMore(0u2245)
  SelectMore(0u2248)
  SelectMore(0u224c)
  SelectMore(0u2250, 0u2253)
  SelectMore(0u2260)
  SelectMore(0u2260, 0u2262)
  SelectMore(0u2264, 0u2267)
  SelectMore(0u226a, 0u226b)
  SelectMore(0u226e, 0u226f)
  SelectMore(0u2272, 0u2273)
  SelectMore(0u2276, 0u2277)
  SelectMore(0u2282, 0u228b)
  SelectMore(0u2295, 0u2299)
  SelectMore(0u229d)
  SelectMore(0u22a0)
  SelectMore(0u22a2, 0u22a5)
  SelectMore(0u22bb, 0u22bd)
  SelectMore(0u22bf, 0u22c3)
  SelectMore(0u22c5)
  SelectMore(0u22da, 0u22db)
  SelectMore(0u22ee, 0u22ef)

  # 罫線、図形
  SelectMore(0u2500, 0u25af)
  SelectMore(0u25b1, 0u25b3)
  SelectMore(0u25b6, 0u25b7)
  SelectMore(0u25ba, 0u25bd)
  SelectMore(0u25c0, 0u25c1)
  SelectMore(0u25c4, 0u25cc)
  SelectMore(0u25ce, 0u25d3)
  SelectMore(0u25d8, 0u25d9)
  SelectMore(0u25e2, 0u25e5)
  SelectMore(0u25af)
  SelectMore(0u25e6)
  SelectMore(0u25ef)
  SelectMore(0u266a)
  SelectMore(0u2756)
  SelectMore(0u29fa, 0u29fb)
  SelectMore(0u2A2F)
  SelectMore(0u2b1a)

  # 一部 Hack ベースにする
  ## 各エディタの可視化文字対策
  SelectFewer(0u2022)
  SelectFewer(0u00b7)
  SelectFewer(0u2024)
  SelectFewer(0u2219)
  SelectFewer(0u25d8)
  SelectFewer(0u25e6)
  ## Cent Sign, Pound Sign, Yen Sign
  SelectFewer(0u00A2)
  SelectFewer(0u00A3)
  SelectFewer(0u00A5)
  "

########################################
# Generate script for modified Hack Material
########################################

cat > ${tmpdir}/${modified_hack_material_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified Hack Material")

# Set parameters
input_list  = ["${input_hack_regular}",    "${input_hack_bold}"]
input_mod_arrow_list  = ["${input_mod_arrow_regular}",    "${input_mod_arrow_bold}"]
output_list = ["${modified_hack_material_regular}", "${modified_hack_material_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])

  # 修正した矢印記号グリフの取り込み
  Select(0u2190, 0u2199)
  SelectMore(0u21E0, 0u21E3) # Dashed Arrow
  SelectMore(0u21D0, 0u21D9) # Double Arrow
  Clear()
  MergeFonts(input_mod_arrow_list[i])

  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  # broken bar に貼り付ける素材準備 (パイプ記号を使うため、後述のパイプ破断線化より前に処理する)
  Select(0u007c); Copy()
  Select(0u0090); Paste(); Scale(100, 25)

  # パイプの破断線化 (broken bar を縦に拡大)
  Select(0u00a6); Copy()
  Select(0u007c); Paste()
  Scale(100, 114)

  # 破断線化したパイプ記号と broken bar の区別を付きやすくする
  Select(0u0090); Copy()
  Select(0u00a6); Paste(); PasteWithOffset(0, 350); PasteWithOffset(0, -350)
  Select(0u0090); Clear()

  # 0 生成
  Select(0u004f); Copy()
  Select(0u0030); Paste(); Scale(99, 100)
  Select(0u00b7); Copy()
  Select(0ufff0); Paste(); Scale(75, 100); Copy()
  Select(0u0030); PasteInto()
  Select(0ufff0); Clear()

  # クォーテーションの拡大
  Select(0u0022)
  SelectMore(0u0027)
  SelectMore(0u0060)
  Scale(110)

  # ; : , . の拡大
  Select(0u003a)
  SelectMore(0u003b)
  SelectMore(0u002c)
  SelectMore(0u002e)
  Scale(108)
  ## 拡大後の位置合わせ
  Select(0u003b); Move(0, 18) # ;
  Select(0u002e); Move(0, 5)  # .
  Select(0u002c); Move(0, -8) # ,

  # Eclipse Pleiades 半角スペース記号 (U+1d1c) 対策
  Select(0u054d); Copy()
  Select(0u1d1c); Paste()
  Scale(85, 60)

  # 左右の波括弧の縦位置合わせ (Regular だけ)
  if (i == 0)
    Select(0u007D); Move(0, 5)
  endif

  # 結合分音記号は全て源柔ゴシックをベースにするため削除する
  Select(0u0300, 0u036f); Clear()

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for extracting evacuation symbol from hinting for HackGen
########################################

cat > ${tmpdir}/${modified_hack_evacuate_from_hinting_generator} << _EOT_
#!$fontforge_command -script

Print("Generate evacuation symbol from hinting for HackGen")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack_material_regular}", "${tmpdir}/${modified_hack_material_bold}"]
output_list = ["${modified_hack_evacuate_from_hinting_regular}", "${modified_hack_evacuate_from_hinting_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()

  Scale(${hack_shrink_x}, ${hack_shrink_y}, 0, 0)

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen_half_width} - ${hack_width} * ${hack_shrink_x} / 100) / 2)) # -8
  width_pt = ${hackgen_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # 特定の記号のみを残し、残りを削除
  SelectNone()
  ${select_evacuate_from_hinting}
  SelectInvert()
  Clear()

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for extracting evacuation symbol from hinting for HackGen35
########################################

cat > ${tmpdir}/${modified_hack35_evacuate_from_hinting_generator} << _EOT_
#!$fontforge_command -script

Print("Generate evacuation symbol from hinting for HackGen")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack_material_regular}", "${tmpdir}/${modified_hack_material_bold}"]
output_list = ["${modified_hack35_evacuate_from_hinting_regular}", "${modified_hack35_evacuate_from_hinting_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen35_half_width} - ${hack_width}) / 2)) # -8
  width_pt = ${hackgen35_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # 特定の記号のみを残し、残りを削除
  SelectNone()
  ${select_evacuate_from_hinting}
  SelectInvert()
  Clear()

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate extraction powerline symbol script for HackGen
########################################

cat > ${tmpdir}/${modified_hack_powerline_generator} << _EOT_
#!$fontforge_command -script

Print("Generate powerline symbol for HackGen")

# Set parameters
input_list  = ["${input_nerd_patched_hack_regular}",    "${input_nerd_patched_hack_bold}"]
output_list = ["${modified_hack_powerline_regular}", "${modified_hack_powerline_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])

  # powerline extra の記号を残し、残りを削除
  SelectNone()
  ${powerline_extra_symbols}
  SelectInvert()
  Clear()

  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  Scale(${hack_shrink_x}, ${hack_shrink_y}, 0, 0)

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen_half_width} - ${hack_width} * ${hack_shrink_x} / 100) / 2)) # -8
  width_pt = ${hackgen_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # パスの小数点以下を切り捨て
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate extraction powerline symbol script for HackGen35
########################################

cat > ${tmpdir}/${modified_hack35_powerline_generator} << _EOT_
#!$fontforge_command -script

Print("Generate powerline symbol for HackGen35")

# Set parameters
input_list  = ["${input_nerd_patched_hack_regular}",    "${input_nerd_patched_hack_bold}"]
output_list = ["${modified_hack35_powerline_regular}", "${modified_hack35_powerline_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])

  # powerline extra の記号を残し、残りを削除
  SelectNone()
  ${powerline_extra_symbols}
  SelectInvert()
  Clear()

  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen35_half_width} - ${hack_width}) / 2)) # -8
  width_pt = ${hackgen35_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for box drawing light for HackGen
########################################

cat > ${tmpdir}/${modified_hack_box_drawing_light_generator} << _EOT_
#!$fontforge_command -script

Print("Generate box drawing light for HackGen")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack_material_regular}", "${tmpdir}/${modified_hack_material_bold}"]
output_list = ["${modified_hack_box_drawing_light_regular}", "${modified_hack_box_drawing_light_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()

  Scale(${hack_shrink_x}, ${hack_shrink_y}, 0, 0)

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen_half_width} - ${hack_width} * ${hack_shrink_x} / 100) / 2)) # -8
  width_pt = ${hackgen_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # 特定の記号のみを残し、残りを削除
  SelectNone()
  ${box_drawing_light_symbols}
  SelectInvert()
  Clear()

  # 罫線記号、ブロック記号が上下左右で繋がるように調整
  SelectNone()
  ${box_drawing_light_symbols}
  SelectFewer(0u2580, 0u259F)
  Scale(100, 110, 0, 0)
  Select(0u2580, 0u259F); Scale(100, 114, 0, 250); Scale(115, 100); SetWidth(width_pt, 0)

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for box drawing light from hinting for HackGen35
########################################

cat > ${tmpdir}/${modified_hack35_box_drawing_light_generator} << _EOT_
#!$fontforge_command -script

Print("Generate box drawing light for HackGen")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack_material_regular}", "${tmpdir}/${modified_hack_material_bold}"]
output_list = ["${modified_hack35_box_drawing_light_regular}", "${modified_hack35_box_drawing_light_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen35_half_width} - ${hack_width}) / 2)) # -8
  width_pt = ${hackgen35_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # 特定の記号のみを残し、残りを削除
  SelectNone()
  ${box_drawing_light_symbols}
  SelectInvert()
  Clear()

  # 罫線記号、ブロック記号が上下左右で繋がるように調整
  SelectNone()
  ${box_drawing_light_symbols}
  SelectFewer(0u2580, 0u259F)
  Scale(100, 110, 0, 0)
  Select(0u2580, 0u259F); Scale(100, 114, 0, 250); Scale(114, 100); SetWidth(width_pt, 0)

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate extraction Nerd Fonts script for HackGen Console
########################################

cat > ${tmpdir}/${modified_hackgen_nerd_console_symbol_generator} << _EOT_
#!$fontforge_command -script

Print("Generate Nerd Fonts symbol for HackGen")

# Set parameters
input_list  = ["${input_nerd_patched_hack_regular}",    "${input_nerd_patched_hack_bold}"]
output_list = ["${modified_hackgen_nerd_console_symbol_regular}", "${modified_hackgen_nerd_console_symbol_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])

  # Nerd Fonts の記号を残し、残りを削除
  SelectNone()
  ${select_nerd_symbols}
  SelectInvert()
  Clear()

  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  Scale(${hack_shrink_x}, ${hack_shrink_y}, 0, 0)

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen_half_width} - ${hack_width} * ${hack_shrink_x} / 100) / 2)) # -8
  width_pt = ${hackgen_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate extraction Nerd Fonts script for HackGen35 Console
########################################

cat > ${tmpdir}/${modified_hackgen35_nerd_console_symbol_generator} << _EOT_
#!$fontforge_command -script

Print("Generate Nerd Fonts symbol for HackGen35")

# Set parameters
input_list  = ["${input_nerd_patched_hack_regular}",    "${input_nerd_patched_hack_bold}"]
output_list = ["${modified_hackgen35_nerd_console_symbol_regular}", "${modified_hackgen35_nerd_console_symbol_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])

  # Nerd Fonts の記号を残し、残りを削除
  SelectNone()
  ${select_nerd_symbols}
  SelectInvert()
  Clear()

  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  Scale(${hack_shrink_x}, ${hack_shrink_y}, 0, 0)

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen35_half_width} - ${hack_width}) / 2)) # -8
  width_pt = ${hackgen35_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified Hack console
########################################

cat > ${tmpdir}/${modified_hack_console_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified Hack Console")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack_material_regular}", "${tmpdir}/${modified_hack_material_bold}"]
output_list = ["${modified_hack_console_regular}", "${modified_hack_console_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()

  Scale(${hack_shrink_x}, ${hack_shrink_y}, 0, 0)

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen_half_width} - ${hack_width} * ${hack_shrink_x} / 100) / 2)) # -8
  width_pt = ${hackgen_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # ヒンティング回避のため特定記号の削除
  SelectNone()
  ${box_drawing_light_symbols}
  ${select_evacuate_from_hinting}
  Clear()

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified Hack35 console
########################################

cat > ${tmpdir}/${modified_hack35_console_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified Hack35 Console")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack_material_regular}", "${tmpdir}/${modified_hack_material_bold}"]
output_list = ["${modified_hack35_console_regular}", "${modified_hack35_console_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen35_half_width} - ${hack_width}) / 2)) # -8
  width_pt = ${hackgen35_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # ヒンティング回避のため特定記号の削除
  SelectNone()
  ${box_drawing_light_symbols}
  ${select_evacuate_from_hinting}
  Clear()

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified Hack
########################################

cat > ${tmpdir}/${modified_hack_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified Hack")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack_console_regular}", "${tmpdir}/${modified_hack_console_bold}"]
output_list = ["${modified_hack_regular}", "${modified_hack_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])

  # Remove ambiguous glyphs
  SelectNone()
  ${select_glyph_is_not_console}
  Clear()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified Hack35
########################################

cat > ${tmpdir}/${modified_hack35_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified Hack")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack35_console_regular}", "${tmpdir}/${modified_hack35_console_bold}"]
output_list = ["${modified_hack35_regular}", "${modified_hack35_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])

  # Remove ambiguous glyphs
  SelectNone()
  ${select_glyph_is_not_console}
  Clear()

  # Save modified Hack
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified GenJyuuGothicL
########################################

cat > ${tmpdir}/${modified_genjyuu_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified GenJyuuGothicL")

# Set parameters
hack = "${tmpdir}/${modified_hack_regular}"
input_list  = ["${input_genjyuu_regular}",    "${input_genjyuu_bold}"]
improved_legibility_list  = ["${input_improved_legibility_regular}",    "${input_improved_legibility_bold}"]
reiwa_list  = ["${input_reiwa_regular}",    "${input_reiwa_bold}"]
ideographic_space = "$input_ideographic_space"
output_list = ["${modified_genjyuu_regular}", "${modified_genjyuu_bold}"]

fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]

Print("Get trim target glyph from Hack")
Open(hack)
i = 0
end_hack = 65535
hack_exist_glyph_array = Array(end_hack)
while (i < end_hack)
  if (i % 5000 == 0)
    Print("Processing progress: " + i)
  endif
  if (WorthOutputting(i))
    hack_exist_glyph_array[i] = 1
  else
    hack_exist_glyph_array[i] = 0
  endif
  i++
endloop
Close()

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open GenJyuuGothicL
  Print("Open " + input_list[i])
  Open(improved_legibility_list[i])
  MergeFonts(reiwa_list[i])
  MergeFonts(ideographic_space)
  MergeFonts(input_list[i])
  if (fontstyle_list[i] == "Bold")
    Select(0u00AB)
    SelectMore(0u00AE)
    SelectMore(0u00BB)
    SelectMore(0u00BF)
    Clear()
    MergeFonts("$input_fix_genjyuu_bold")
  endif

  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  ii = 0
  end_genjyuu = end_hack
  halfwidth_array = Array(end_genjyuu)
  i_halfwidth = 0
  Print("Half width check loop start")
  while ( ii < end_genjyuu )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii))
        Select(ii)
        if (hack_exist_glyph_array[ii] == 1)
          Clear()
        elseif (GlyphInfo("Width")<768)
          halfwidth_array[i_halfwidth] = ii
          i_halfwidth = i_halfwidth + 1
        endif
      endif
      ii = ii + 1
  endloop
  Print("Half width check loop end")

  Print("Full SetWidth start")
  move_pt = $(((${hackgen_full_width} - ${genjyuu_width}) / 2)) # 26
  width_pt = ${hackgen_full_width} # 1076
  SelectWorthOutputting()
  ii=0
  while (ii < i_halfwidth)
      SelectFewer(halfwidth_array[ii])
      ii = ii + 1
  endloop
  Move(move_pt, 0)
  SetWidth(width_pt)
  Print("Full SetWidth end")

  SelectNone()

  Print("Half SetWidth start")
  move_pt = $(((${hackgen_half_width} - ${genjyuu_width} / 2) / 2)) # 13
  width_pt = ${hackgen_half_width} # 358
  ii=0
  while (ii < i_halfwidth)
      SelectMore(halfwidth_array[ii])
      ii = ii + 1
  endloop
  Move(move_pt, 0)
  SetWidth(width_pt)
  Print("Half SetWidth end")

  # broken bar は Hack ベースにする
  Select(0u00a6); Clear()

  # Edit zenkaku brackets
  Print("Edit zenkaku brackets")
  bracket_move = $((${hackgen_half_width} / 7 * 3))
  bracket_scale = 104
  Select(0uff08) # (
  SelectMore(0uff3b) # [
  SelectMore(0uff5b) # {
  Scale(bracket_scale)
  Move(-bracket_move, 0); SetWidth(${hackgen_full_width})
  Select(0uff09) # )
  SelectMore(0uff3d) # ]
  SelectMore(0uff5d) # }
  Scale(bracket_scale)
  Move( bracket_move, 0); SetWidth(${hackgen_full_width})

  # 全角 ，．‘’“” の調整
  Select(0uff0e);Scale(155) ; SetWidth(${hackgen_full_width}) # ．
  Select(0uff0c);Scale(145) ; SetWidth(${hackgen_full_width}) # ，
  Select(0u2018);Scale(145) ; SetWidth(${hackgen_full_width}) # ‘
  Select(0u2019);Scale(145) ; SetWidth(${hackgen_full_width}) # ’
  Select(0u201c);Scale(145) ; SetWidth(${hackgen_full_width}) # “
  Select(0u201d);Scale(145) ; SetWidth(${hackgen_full_width}) # ”

  # 下限で見切れているグリフの調整
  Select(0uff47); Scale(100, 91) # ｇ
  Select(0uff4a); Scale(100, 91) # ｊ

  # カーニング情報を削除
  lookups = GetLookups("GPOS"); numlookups = SizeOf(lookups); j = 0;
  while (j < numlookups)
    if (Strstr(lookups[j], 'halt') >= 0 \\
        || Strstr(lookups[j], 'vhal') >= 0 \\
        || Strstr(lookups[j], 'palt') >= 0 \\
        || Strstr(lookups[j], 'vpal') >= 0 \\
        || Strstr(lookups[j], 'kern') >= 0 \\
      )
      RemoveLookup(lookups[j]);
    endif
    j++
  endloop

  # Save modified GenJyuuGothicL
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])
  Close()

  # Open new file
  Print("Generate Genjyuu ttf")
  New()
  # Set encoding to Unicode-bmp
  Reencode("unicode")
  # Set configuration
  SetFontNames("modified-genjyuu" + fontstyle_list[i])
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen_ascent})
  SetOS2Value("WinDescent",            ${hackgen_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  MergeFonts("${tmpdir}/" + output_list[i])
  Generate("${tmpdir}/" + output_list[i] + ".ttf", "")
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified GenJyuuGothicL for HackGen35
########################################

cat > ${tmpdir}/${modified_genjyuu35_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified GenJyuuGothicL - 35")

# Set parameters
hack = "${tmpdir}/${modified_hack35_regular}"
input_list  = ["${input_genjyuu_regular}",    "${input_genjyuu_bold}"]
improved_legibility_list  = ["${input_improved_legibility_regular}",    "${input_improved_legibility_bold}"]
reiwa_list  = ["${input_reiwa_regular}",    "${input_reiwa_bold}"]
ideographic_space = "$input_ideographic_space"
output_list = ["${modified_genjyuu35_regular}", "${modified_genjyuu35_bold}"]

fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]

Print("Get trim target glyph from Hack")
Open(hack)
i = 0
end_hack = 65535
hack_exist_glyph_array = Array(end_hack)
while (i < end_hack)
  if (i % 5000 == 0)
    Print("Processing progress: " + i)
  endif
  if (WorthOutputting(i))
    hack_exist_glyph_array[i] = 1
  else
    hack_exist_glyph_array[i] = 0
  endif
  i++
endloop
Close()

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open GenJyuuGothicL
  Print("Open " + input_list[i])
  Open(improved_legibility_list[i])
  MergeFonts(reiwa_list[i])
  MergeFonts(ideographic_space)
  MergeFonts(input_list[i])
  if (fontstyle_list[i] == "Bold")
    Select(0u00AB)
    SelectMore(0u00AE)
    SelectMore(0u00BB)
    SelectMore(0u00BF)
    Clear()
    MergeFonts("$input_fix_genjyuu_bold")
  endif

  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  ii = 0
  end_genjyuu = end_hack
  halfwidth_array = Array(end_genjyuu)
  i_halfwidth = 0
  Print("Half width check loop start")
  while ( ii < end_genjyuu )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii))
        Select(ii)
        if (hack_exist_glyph_array[ii] == 1)
          Clear()
        elseif (GlyphInfo("Width")<768)
          halfwidth_array[i_halfwidth] = ii
          i_halfwidth = i_halfwidth + 1
        endif
      endif
      ii = ii + 1
  endloop
  Print("Half width check loop end")

  Print("Full SetWidth start")
  move_pt = $(((${hackgen35_full_width} - ${genjyuu_width}) / 2)) # 3
  width_pt = ${hackgen35_full_width} # 1030
  SelectWorthOutputting()
  ii=0
  while (ii < i_halfwidth)
      SelectFewer(halfwidth_array[ii])
      ii = ii + 1
  endloop
  Move(move_pt, 0)
  SetWidth(width_pt)
  Print("Full SetWidth end")

  SelectNone()

  Print("Half SetWidth start")
  move_pt = $(((${hackgen35_half_width} - ${genjyuu_width} / 2) / 2)) # 35
  width_pt = ${hackgen35_half_width} # 618
  ii=0
  while (ii < i_halfwidth)
      SelectMore(halfwidth_array[ii])
      ii = ii + 1
  endloop
  Move(move_pt, 0)
  SetWidth(width_pt)
  Print("Half SetWidth end")

  # broken bar は Hack ベースにする
  Select(0u00a6); Clear()

  # Edit zenkaku brackets
  Print("Edit zenkaku brackets")
  bracket_move = $((${hackgen35_half_width} / 7 * 3))
  bracket_scale = 104
  Select(0uff08) # (
  SelectMore(0uff3b) # [
  SelectMore(0uff5b) # {
  Scale(bracket_scale)
  Move(-bracket_move, 0); SetWidth(${hackgen35_full_width})
  Select(0uff09) # )
  SelectMore(0uff3d) # ]
  SelectMore(0uff5d) # }
  Scale(bracket_scale)
  Move( bracket_move, 0); SetWidth(${hackgen35_full_width})

  # 全角 ，．‘’“” の調整
  Select(0uff0e);Scale(155) ; SetWidth(${hackgen35_full_width}) # ．
  Select(0uff0c);Scale(145) ; SetWidth(${hackgen35_full_width}) # ，
  Select(0u2018);Scale(145) ; SetWidth(${hackgen35_full_width}) # ‘
  Select(0u2019);Scale(145) ; SetWidth(${hackgen35_full_width}) # ’
  Select(0u201c);Scale(145) ; SetWidth(${hackgen35_full_width}) # “
  Select(0u201d);Scale(145) ; SetWidth(${hackgen35_full_width}) # ”

  # カーニング情報を削除
  lookups = GetLookups("GPOS"); numlookups = SizeOf(lookups); j = 0;
  while (j < numlookups)
    if (Strstr(lookups[j], 'halt') >= 0 \\
        || Strstr(lookups[j], 'vhal') >= 0 \\
        || Strstr(lookups[j], 'palt') >= 0 \\
        || Strstr(lookups[j], 'vpal') >= 0 \\
        || Strstr(lookups[j], 'kern') >= 0 \\
      )
      RemoveLookup(lookups[j]);
    endif
    j++
  endloop

  # Save modified GenJyuuGothicL
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])
  Close()

  # Open new file
  Print("Generate Genjyuu ttf")
  New()
  # Set encoding to Unicode-bmp
  Reencode("unicode")
  # Set configuration
  SetFontNames("modified-genjyuu" + fontstyle_list[i])
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen35_ascent})
  SetOS2Value("WinDescent",            ${hackgen35_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen35_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen35_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 3, 2, 2, 3, 2, 2, 7])

  MergeFonts("${tmpdir}/" + output_list[i])
  Generate("${tmpdir}/" + output_list[i] + ".ttf", "")
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified GenJyuuGothicL Console
########################################

cat > ${tmpdir}/${modified_genjyuu_console_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified GenJyuuGothicL Console")

# Set parameters
hack = "${tmpdir}/${modified_hack_material_regular}"
input_list  = ["${tmpdir}/${modified_genjyuu_regular}.ttf", "${tmpdir}/${modified_genjyuu_bold}.ttf"]
output_list = ["${modified_genjyuu_console_regular}", "${modified_genjyuu_console_bold}"]

Print("Get trim target glyph from Hack")
Open(hack)
i = 0
end_hack = 65535
hack_exist_glyph_array = Array(end_hack)
while (i < end_hack)
  if (i % 5000 == 0)
    Print("Processing progress: " + i)
  endif
  if (WorthOutputting(i))
    hack_exist_glyph_array[i] = 1
  else
    hack_exist_glyph_array[i] = 0
  endif
  i++
endloop
Close()

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open GenJyuuGothicL
  Print("Open " + input_list[i])
  Open(input_list[i])

  ii = 0
  end_genjyuu = end_hack
  Print("Begin delete the glyphs contained in Hack")
  SelectNone()
  ${box_drawing_light_symbols}
  while ( ii < end_genjyuu )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii) && hack_exist_glyph_array[ii] == 1)
        SelectMore(ii)
      endif
      ii = ii + 1
  endloop
  Clear()
  Print("End delete the glyphs contained in Hack")

  # 結合分音記号は全て源柔ゴシック収録のものを使用する
  Select(0u0300, 0u036f)
  move_pt = $(((${hackgen_half_width} - ${hackgen_full_width}) / 2))
  Move(move_pt, 0)
  SetWidth(${hackgen_half_width}, 0)

  # Save modified GenJyuuGothicL
  Print("Generate " + output_list[i])
  Generate("${tmpdir}/" + output_list[i] + ".ttf", "")
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified GenJyuuGothicL Console for HackGen35
########################################

cat > ${tmpdir}/${modified_genjyuu35_console_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified GenJyuuGothicL Console - 35")

# Set parameters
hack = "${tmpdir}/${modified_hack_material_regular}"
input_list  = ["${tmpdir}/${modified_genjyuu35_regular}.ttf", "${tmpdir}/${modified_genjyuu35_bold}.ttf"]
output_list = ["${modified_genjyuu35_console_regular}", "${modified_genjyuu35_console_bold}"]

Print("Get trim target glyph from Hack")
Open(hack)
i = 0
end_hack = 65535
hack_exist_glyph_array = Array(end_hack)
while (i < end_hack)
  if (i % 5000 == 0)
    Print("Processing progress: " + i)
  endif
  if (WorthOutputting(i))
    hack_exist_glyph_array[i] = 1
  else
    hack_exist_glyph_array[i] = 0
  endif
  i++
endloop
Close()

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open GenJyuuGothicL
  Print("Open " + input_list[i])
  Open(input_list[i])

  ii = 0
  end_genjyuu = end_hack
  Print("Begin delete the glyphs contained in Hack")
  SelectNone()
  ${box_drawing_light_symbols}
  while ( ii < end_genjyuu )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii) && hack_exist_glyph_array[ii] == 1)
        SelectMore(ii)
      endif
      ii = ii + 1
  endloop
  Clear()
  Print("End delete the glyphs contained in Hack")

  # 結合分音記号は全て源柔ゴシック収録のものを使用する
  Select(0u0300, 0u036f)
  move_pt = $(((${hackgen35_half_width} - ${hackgen35_full_width}) / 2))
  Move(move_pt, 0)
  SetWidth(${hackgen35_half_width}, 0)

  # Save modified GenJyuuGothicL
  Print("Generate " + output_list[i])
  Generate("${tmpdir}/" + output_list[i] + ".ttf", "")
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for HackGen
########################################

cat > ${tmpdir}/${hackgen_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate HackGen")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack_regular}", \\
                     "${tmpdir}/${modified_hack_bold}"]
fontfamily        = "${hackgen_familyname}"
fontfamilysuffix  = "${hackgen_familyname_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen_ascent})
  SetOS2Value("WinDescent",            ${hackgen_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_


########################################
# Generate extraction nerd symbols script for HackGen Console
########################################

cat > ${tmpdir}/${hackgen_nerd_console_symbol_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate extraction nerd symbols script for HackGen")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hackgen_nerd_console_symbol_regular}", \\
                     "${tmpdir}/${modified_hackgen_nerd_console_symbol_bold}"]
powerline_list = ["${tmpdir}/${modified_hack_powerline_regular}", \\
                      "${tmpdir}/${modified_hack_powerline_bold}"]
fontfamily        = "${hackgen_evacuation_nerd_familyname}"
fontfamilysuffix  = "${hackgen_console_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen_ascent})
  SetOS2Value("WinDescent",            ${hackgen_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])
  MergeFonts(powerline_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate extraction nerd symbols script for HackGen35 Console
########################################

cat > ${tmpdir}/${hackgen35_nerd_console_symbol_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate extraction nerd symbols script for HackGen35")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hackgen35_nerd_console_symbol_regular}", \\
                     "${tmpdir}/${modified_hackgen35_nerd_console_symbol_bold}"]
powerline_list = ["${tmpdir}/${modified_hack35_powerline_regular}", \\
                      "${tmpdir}/${modified_hack35_powerline_bold}"]
fontfamily        = "${hackgen35_evacuation_nerd_familyname}"
fontfamilysuffix  = "${hackgen_console_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen35_ascent})
  SetOS2Value("WinDescent",            ${hackgen35_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen35_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen35_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 3, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])
  MergeFonts(powerline_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate extraction evacuation symbol from hinting for HackGen
########################################

cat > ${tmpdir}/${hackgen_evacuate_from_hinting_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate extraction evacuation symbol from hinting for HackGen")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack_evacuate_from_hinting_regular}", \\
                     "${tmpdir}/${modified_hack_evacuate_from_hinting_bold}"]
fontfamily        = "${hackgen_evacuation_symbol_familyname}"
fontfamilysuffix  = "${hackgen_familyname_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen_ascent})
  SetOS2Value("WinDescent",            ${hackgen_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate extraction evacuation symbol from hinting for HackGen35
########################################

cat > ${tmpdir}/${hackgen35_evacuate_from_hinting_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate extraction evacuation symbol from hinting for HackGen35")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack35_evacuate_from_hinting_regular}", \\
                     "${tmpdir}/${modified_hack35_evacuate_from_hinting_bold}"]
fontfamily        = "${hackgen35_evacuation_symbol_familyname}"
fontfamilysuffix  = "${hackgen_familyname_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen35_ascent})
  SetOS2Value("WinDescent",            ${hackgen35_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen35_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen35_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 3, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate extraction box drawing light for HackGen
########################################

cat > ${tmpdir}/${hackgen_box_drawing_light_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate extraction box drawing light for HackGen")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack_box_drawing_light_regular}", \\
                     "${tmpdir}/${modified_hack_box_drawing_light_bold}"]
fontfamily        = "${hackgen_box_drawing_light_familyname}"
fontfamilysuffix  = "${hackgen_familyname_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen_ascent})
  SetOS2Value("WinDescent",            ${hackgen_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate extraction box drawing light for HackGen35
########################################

cat > ${tmpdir}/${hackgen35_box_drawing_light_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate extraction box drawing light for HackGen35")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack35_box_drawing_light_regular}", \\
                     "${tmpdir}/${modified_hack35_box_drawing_light_bold}"]
fontfamily        = "${hackgen35_box_drawing_light_familyname}"
fontfamilysuffix  = "${hackgen_familyname_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen35_ascent})
  SetOS2Value("WinDescent",            ${hackgen35_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen35_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen35_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 3, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for HackGen Console
########################################

cat > ${tmpdir}/${hackgen_console_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate HackGen Console")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack_console_regular}", \\
                     "${tmpdir}/${modified_hack_console_bold}"]
fontfamily        = "${hackgen_familyname}"
fontfamilysuffix  = "${hackgen_console_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen_ascent})
  SetOS2Value("WinDescent",            ${hackgen_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for HackGen35
########################################

cat > ${tmpdir}/${hackgen35_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate HackGen35")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack35_regular}", \\
                     "${tmpdir}/${modified_hack35_bold}"]
fontfamily        = "${hackgen35_familyname}"
fontfamilysuffix  = "${hackgen35_familyname_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen35_ascent})
  SetOS2Value("WinDescent",            ${hackgen35_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen35_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen35_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 3, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for HackGen35 Console
########################################

cat > ${tmpdir}/${hackgen35_console_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate HackGen35 Console")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack35_console_regular}", \\
                     "${tmpdir}/${modified_hack35_console_bold}"]
fontfamily        = "${hackgen35_familyname}"
fontfamilysuffix  = "${hackgen_console_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "${copyright}"
version           = "${hackgen_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  # Set configuration
  if (fontfamilysuffix != "")
        SetFontNames(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i], \\
                     fontfamily + " " + fontfamilysuffix, \\
                     fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  else
        SetFontNames(fontfamily + "-" + fontstyle_list[i], \\
                     fontfamily, \\
                     fontfamily + " " + fontstyle_list[i], \\
                     fontstyle_list[i], \\
                     copyright, version)
  endif
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${hackgen35_ascent})
  SetOS2Value("WinDescent",            ${hackgen35_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${hackgen35_ascent})
  SetOS2Value("HHeadDescent",         -${hackgen35_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 3, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate HackGen
########################################

# Generate Material
$fontforge_command -script ${tmpdir}/${modified_hack_material_generator} 2> $redirection_stderr || exit 4

# Generate Console
$fontforge_command -script ${tmpdir}/${modified_hack_console_generator} 2> $redirection_stderr || exit 4

# Generate Modiifed Hack
$fontforge_command -script ${tmpdir}/${modified_hack_generator} 2> $redirection_stderr || exit 4

# Generate Modified GenJyuu
$fontforge_command -script ${tmpdir}/${modified_genjyuu_generator} 2> $redirection_stderr || exit 4

# Generate powerline Symbol
$fontforge_command -script ${tmpdir}/${modified_hack_powerline_generator} 2> $redirection_stderr || exit 4

# Generate powerline Symbol
$fontforge_command -script ${tmpdir}/${modified_hack35_powerline_generator} 2> $redirection_stderr || exit 4

# Generate Modified HackGen Console Nerd Symbol
$fontforge_command -script ${tmpdir}/${modified_hackgen_nerd_console_symbol_generator} 2> $redirection_stderr || exit 4

# Generate Modified HackGen35 Console Nerd Symbol
$fontforge_command -script ${tmpdir}/${modified_hackgen35_nerd_console_symbol_generator} 2> $redirection_stderr || exit 4

# Generate Hack evacuation symbol
$fontforge_command -script ${tmpdir}/${modified_hack_evacuate_from_hinting_generator} 2> $redirection_stderr || exit 4

# Generate Hack 35 evacuation symbol
$fontforge_command -script ${tmpdir}/${modified_hack35_evacuate_from_hinting_generator} 2> $redirection_stderr || exit 4

# Generate Hack box drawing light symbols
$fontforge_command -script ${tmpdir}/${modified_hack_box_drawing_light_generator} 2> $redirection_stderr || exit 4

# Generate Hack 35 box drawing light evacuation symbols
$fontforge_command -script ${tmpdir}/${modified_hack35_box_drawing_light_generator} 2> $redirection_stderr || exit 4

# Generate Modified GenJyuu Console
$fontforge_command -script ${tmpdir}/${modified_genjyuu_console_generator} 2> $redirection_stderr || exit 4

# Generate HackGen
$fontforge_command -script ${tmpdir}/${hackgen_generator} 2> $redirection_stderr || exit 4

# Generate HackGen Console
$fontforge_command -script ${tmpdir}/${hackgen_console_generator} 2> $redirection_stderr || exit 4

# Generate Console - 35
$fontforge_command -script ${tmpdir}/${modified_hack35_console_generator} 2> $redirection_stderr || exit 4

# Generate Modiifed Hack - 35
$fontforge_command -script ${tmpdir}/${modified_hack35_generator} 2> $redirection_stderr || exit 4

# Generate Modified GenJyuu - 35
$fontforge_command -script ${tmpdir}/${modified_genjyuu35_generator} 2> $redirection_stderr || exit 4

# Generate Modified GenJyuu Console - 35
$fontforge_command -script ${tmpdir}/${modified_genjyuu35_console_generator} 2> $redirection_stderr || exit 4

# Generate HackGen - 35
$fontforge_command -script ${tmpdir}/${hackgen35_generator} 2> $redirection_stderr || exit 4

# Generate HackGen Console - 35
$fontforge_command -script ${tmpdir}/${hackgen35_console_generator} 2> $redirection_stderr || exit 4

# Generate HackGen Nerd Symbol
$fontforge_command -script ${tmpdir}/${hackgen_nerd_console_symbol_generator} 2> $redirection_stderr || exit 4

# Generate HackGen35 Nerd Symbol
$fontforge_command -script ${tmpdir}/${hackgen35_nerd_console_symbol_generator} 2> $redirection_stderr || exit 4

# Generate HackGen evacuation symbol from hinting
$fontforge_command -script ${tmpdir}/${hackgen_evacuate_from_hinting_generator} 2> $redirection_stderr || exit 4

# Generate HackGen35 evacuation symbol from hinting
$fontforge_command -script ${tmpdir}/${hackgen35_evacuate_from_hinting_generator} 2> $redirection_stderr || exit 4

# Generate HackGen box drawing light symbols from hinting
$fontforge_command -script ${tmpdir}/${hackgen_box_drawing_light_generator} 2> $redirection_stderr || exit 4

# Generate HackGen35 box drawing light symbols from hinting
$fontforge_command -script ${tmpdir}/${hackgen35_box_drawing_light_generator} 2> $redirection_stderr || exit 4

# Add hinting HackGen Regular
for f in ${hackgen_familyname}-Regular.ttf ${hackgen_familyname}${hackgen_console_suffix}-Regular.ttf
do
  ttfautohint -m hinting_post_processing/hackgen-regular-ctrl.txt -l 6 -r 45 -X "12-" -a qsq -D latn -W -I "$f" "hinted_${f}"
done
# Add hinting HackGen Bold
for f in ${hackgen_familyname}-Bold.ttf ${hackgen_familyname}${hackgen_console_suffix}-Bold.ttf
do
  ttfautohint -m hinting_post_processing/hackgen-bold-ctrl.txt -l 6 -r 45 -X "12-" -a qsq -D latn -W -I "$f" "hinted_${f}"
done
# Add hinting HackGen35 Regular
for f in ${hackgen35_familyname}-Regular.ttf ${hackgen35_familyname}${hackgen_console_suffix}-Regular.ttf
do
  ttfautohint -m hinting_post_processing/hackgen35-regular-ctrl.txt -l 6 -r 45 -X "12-" -a qsq -D latn -W -I "$f" "hinted_${f}"
done
# Add hinting HackGen35 Bold
for f in ${hackgen35_familyname}-Bold.ttf ${hackgen35_familyname}${hackgen_console_suffix}-Bold.ttf
do
  ttfautohint -m hinting_post_processing/hackgen35-bold-ctrl.txt -l 6 -r 45 -X "12-" -a qsq -D latn -W -I "$f" "hinted_${f}"
done

for style in Regular Bold
do
  if [ "${style}" = 'Regular' ]; then
    marge_genjyuu_regular="${tmpdir}/${modified_genjyuu_regular}.ttf"
    marge_genjyuu_console_regular="${tmpdir}/${modified_genjyuu_console_regular}.ttf"
    marge_genjyuu35_regular="${tmpdir}/${modified_genjyuu35_regular}.ttf"
    marge_genjyuu35_console_regular="${tmpdir}/${modified_genjyuu35_console_regular}.ttf"
  fi
  if [ "${style}" = 'Bold' ]; then
    marge_genjyuu_regular="${tmpdir}/${modified_genjyuu_bold}.ttf"
    marge_genjyuu_console_regular="${tmpdir}/${modified_genjyuu_console_bold}.ttf"
    marge_genjyuu35_regular="${tmpdir}/${modified_genjyuu35_bold}.ttf"
    marge_genjyuu35_console_regular="${tmpdir}/${modified_genjyuu35_console_bold}.ttf"
  fi

  hackgen_filename="${hackgen_familyname}-${style}.ttf"
  hackgen_console_filename="${hackgen_familyname}${hackgen_console_suffix}-${style}.ttf"
  hackgen35_filename="${hackgen35_familyname}-${style}.ttf"
  hackgen35_console_filename="${hackgen35_familyname}${hackgen_console_suffix}-${style}.ttf"

  hackgen_nerd_console_filename="${hackgen_familyname}${hackgen_console_suffix}${hackgen_nerd_suffix}-${style}.ttf"
  hackgen35_nerd_console_filename="${hackgen35_familyname}${hackgen_console_suffix}${hackgen_nerd_suffix}-${style}.ttf"
  hackgen_nerd_jp_console_filename="${hackgen_familyname}${hackgen_console_suffix}${hackgen_nerd_jp_suffix}-${style}.ttf"
  hackgen35_nerd_jp_console_filename="${hackgen35_familyname}${hackgen_console_suffix}${hackgen_nerd_jp_suffix}-${style}.ttf"

  # pyftmergeの出力ファイル名が"merged.ttf"で固定なので、並列処理時に競合しないように、それぞれ別のフォルダで作業する

  cdAutoMakeDir() {
    mkdir -p "$1"
    cd "$1"
  }

  # HackGen
  echo "Start pyftmerge: ${hackgen_filename}"
  (
    cdAutoMakeDir "${tmpdir}/parallel_merge/${hackgen_filename}"
    pyftmerge "${base_dir}/hinted_${hackgen_filename}" "${base_dir}/${hackgen_evacuation_symbol_familyname}${hackgen_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "$marge_genjyuu_regular"
    mv merged.ttf "${base_dir}/${hackgen_filename}"
  ) > "${tmpdir}/${hackgen_filename}.pyftmerge_output" 2>&1 &

  # HackGen Console
  echo "Start pyftmerge: ${hackgen_console_filename}"
  (
    cdAutoMakeDir "${tmpdir}/parallel_merge/${hackgen_console_filename}"
    pyftmerge "${base_dir}/hinted_${hackgen_console_filename}" "${base_dir}/${hackgen_evacuation_symbol_familyname}${hackgen_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "${base_dir}/${hackgen_box_drawing_light_familyname}${hackgen_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "$marge_genjyuu_console_regular"
    mv merged.ttf "${base_dir}/${hackgen_console_filename}"
  ) > "${tmpdir}/${hackgen_console_filename}.pyftmerge_output" 2>&1 &

  # HackGen35
  echo "Start pyftmerge: ${hackgen35_filename}"
  (
    cdAutoMakeDir "${tmpdir}/parallel_merge/${hackgen35_filename}"
    pyftmerge "${base_dir}/hinted_${hackgen35_filename}" "${base_dir}/${hackgen35_evacuation_symbol_familyname}${hackgen35_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "$marge_genjyuu35_regular"
    mv merged.ttf "${base_dir}/${hackgen35_filename}"
  ) > "${tmpdir}/${hackgen35_filename}.pyftmerge_output" 2>&1 &

  # HackGen35 Console
  echo "Start pyftmerge: ${hackgen35_console_filename}"
  (
    cdAutoMakeDir "${tmpdir}/parallel_merge/${hackgen35_console_filename}"
    pyftmerge "${base_dir}/hinted_${hackgen35_console_filename}" "${base_dir}/${hackgen35_evacuation_symbol_familyname}${hackgen35_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "${base_dir}/${hackgen35_box_drawing_light_familyname}${hackgen35_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "$marge_genjyuu35_console_regular"
    mv merged.ttf "${base_dir}/${hackgen35_console_filename}"
  ) > "${tmpdir}/${hackgen35_console_filename}.pyftmerge_output" 2>&1 &

  # HackGen Console NF
  echo "Start pyftmerge: ${hackgen_nerd_console_filename}"
  (
    cdAutoMakeDir "${tmpdir}/parallel_merge/${hackgen_nerd_console_filename}"
    pyftmerge "${base_dir}/hinted_${hackgen_console_filename}" "${base_dir}/${hackgen_evacuation_symbol_familyname}${hackgen_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "${base_dir}/${hackgen_box_drawing_light_familyname}${hackgen_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "${base_dir}/${hackgen_evacuation_nerd_familyname}${hackgen_console_suffix}-${style}.ttf"
    pyftmerge merged.ttf "$marge_genjyuu_console_regular"
    mv merged.ttf "${base_dir}/${hackgen_nerd_console_filename}"
    
    cd "${base_dir}"
    ttx -t name "${hackgen_nerd_console_filename}"
    sed -i -e 's/HackGen Console/HackGen Console NF/g; s/HackGenConsole/HackGenConsoleNF/g' "${hackgen_nerd_console_filename%%.ttf}.ttx"
    mv "${hackgen_nerd_console_filename}" "${hackgen_nerd_console_filename}_orig"
    ttx -m "${hackgen_nerd_console_filename}_orig" "${hackgen_nerd_console_filename%%.ttf}.ttx"
  ) > "${tmpdir}/${hackgen_nerd_console_filename}.pyftmerge_output" 2>&1 &

  # HackGen35 Console NF
  echo "Start pyftmerge: ${hackgen35_nerd_console_filename}"
  (
    cdAutoMakeDir "${tmpdir}/parallel_merge/${hackgen35_nerd_console_filename}"
    pyftmerge "${base_dir}/hinted_${hackgen35_console_filename}" "${base_dir}/${hackgen35_evacuation_symbol_familyname}${hackgen35_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "${base_dir}/${hackgen35_box_drawing_light_familyname}${hackgen35_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "${base_dir}/${hackgen35_evacuation_nerd_familyname}${hackgen_console_suffix}-${style}.ttf"
    pyftmerge merged.ttf "$marge_genjyuu35_console_regular"
    mv merged.ttf "${base_dir}/${hackgen35_nerd_console_filename}"
    
    cd "${base_dir}"
    ttx -t name "${hackgen35_nerd_console_filename}"
    sed -i -e 's/HackGen35 Console/HackGen35 Console NF/g; s/HackGen35Console/HackGen35ConsoleNF/g' "${hackgen35_nerd_console_filename%%.ttf}.ttx"
    mv "${hackgen35_nerd_console_filename}" "${hackgen35_nerd_console_filename}_orig"
    ttx -m "${hackgen35_nerd_console_filename}_orig" "${hackgen35_nerd_console_filename%%.ttf}.ttx"
  ) > "${tmpdir}/${hackgen35_nerd_console_filename}.pyftmerge_output" 2>&1 &

  # HackGen Console NFJ
  echo "Start pyftmerge: ${hackgen_nerd_jp_console_filename}"
  (
    cdAutoMakeDir "${tmpdir}/parallel_merge/${hackgen_nerd_jp_console_filename}"
    pyftmerge "${base_dir}/hinted_${hackgen_console_filename}" "${base_dir}/${hackgen_evacuation_symbol_familyname}${hackgen_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "${base_dir}/${hackgen_box_drawing_light_familyname}${hackgen_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "$marge_genjyuu_console_regular"
    pyftmerge merged.ttf "${base_dir}/${hackgen_evacuation_nerd_familyname}${hackgen_console_suffix}-${style}.ttf"
    mv merged.ttf "${base_dir}/${hackgen_nerd_jp_console_filename}"
    
    cd "${base_dir}"
    ttx -t name "${hackgen_nerd_jp_console_filename}"
    sed -i -e 's/HackGen Console/HackGen Console NFJ/g; s/HackGenConsole/HackGenConsoleNFJ/g' "${hackgen_nerd_jp_console_filename%%.ttf}.ttx"
    mv "${hackgen_nerd_jp_console_filename}" "${hackgen_nerd_jp_console_filename}_orig"
    ttx -m "${hackgen_nerd_jp_console_filename}_orig" "${hackgen_nerd_jp_console_filename%%.ttf}.ttx"
  ) > "${tmpdir}/${hackgen_nerd_jp_console_filename}.pyftmerge_output" 2>&1 &

  # HackGen35 Console NFJ
  echo "Start pyftmerge: ${hackgen35_nerd_jp_console_filename}"
  (
    cdAutoMakeDir "${tmpdir}/parallel_merge/${hackgen35_nerd_jp_console_filename}"
    pyftmerge "${base_dir}/hinted_${hackgen35_console_filename}" "${base_dir}/${hackgen35_evacuation_symbol_familyname}${hackgen35_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "${base_dir}/${hackgen35_box_drawing_light_familyname}${hackgen35_familyname_suffix}-${style}.ttf"
    pyftmerge merged.ttf "$marge_genjyuu35_console_regular"
    pyftmerge merged.ttf "${base_dir}/${hackgen35_evacuation_nerd_familyname}${hackgen_console_suffix}-${style}.ttf"
    mv merged.ttf "${base_dir}/${hackgen35_nerd_jp_console_filename}"
    
    cd "${base_dir}"
    ttx -t name "${hackgen35_nerd_jp_console_filename}"
    sed -i -e 's/HackGen35 Console/HackGen35 Console NFJ/g; s/HackGen35Console/HackGen35ConsoleNFJ/g' "${hackgen35_nerd_jp_console_filename%%.ttf}.ttx"
    mv "${hackgen35_nerd_jp_console_filename}" "${hackgen35_nerd_jp_console_filename}_orig"
    ttx -m "${hackgen35_nerd_jp_console_filename}_orig" "${hackgen35_nerd_jp_console_filename%%.ttf}.ttx"
  ) > "${tmpdir}/${hackgen35_nerd_jp_console_filename}.pyftmerge_output" 2>&1 &

  wait
  
  # 並列処理からの出力内容をまとめて出力
  pyftmerged_ttf_files="
    ${hackgen_filename}
    ${hackgen_console_filename}
    ${hackgen35_filename}
    ${hackgen35_console_filename}
    ${hackgen_nerd_console_filename}
    ${hackgen35_nerd_console_filename}
    ${hackgen_nerd_jp_console_filename}
    ${hackgen35_nerd_jp_console_filename}
  "
  for ttf_file in $pyftmerged_ttf_files
  do
    output_filename="${ttf_file}.pyftmerge_output"
    echo "$output_filename" | sed -r "s/(.+)\.pyftmerge_output/# pyftmerge output: \1/"
    cat "${tmpdir}/${output_filename}"
    rm "${tmpdir}/${output_filename}"
  done

done

rm -f hinted_*.ttf
rm -f "${hackgen_evacuation_symbol_familyname}"*.ttf
rm -f "${hackgen35_evacuation_symbol_familyname}"*.ttf
rm -f "${hackgen_evacuation_nerd_familyname}"*.ttf
rm -f "${hackgen35_evacuation_nerd_familyname}"*.ttf
rm -f "${hackgen_box_drawing_light_familyname}"*.ttf
rm -f "${hackgen35_box_drawing_light_familyname}"*.ttf

# Remove temporary directory
if [ "${leaving_tmp_flag}" = "false" ]
then
  echo "Remove temporary files"
  rm -rf $tmpdir
fi

# Exit
echo "Succeeded in generating HackGen!"
exit 0
