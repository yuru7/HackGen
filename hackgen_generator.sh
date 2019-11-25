#!/bin/sh

base_dir=$(cd $(dirname $0); pwd)
# HackGen Generator
hackgen_version="1.4.1"

# Set familyname
familyname_preffix="$1"
hackgen_familyname=${familyname_preffix}"HackGen"
hackgen_familyname_suffix=""
hackgen35_familyname=${hackgen_familyname}"35"
hackgen35_familyname_suffix=""
hackgen_console_suffix="Console"
hackgen_box_drawing_lights_suffix="BoxDrawingLights"

# Set ascent and descent (line width parameters)
hackgen_ascent=901
hackgen_descent=243
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
powerline_patch_path="${base_dir}/fontpatcher-develop/scripts/powerline-fontpatcher"

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
modified_hack_material_generator="modified_hack_material_generator.pe"
modified_hack_material_regular="Modified-Hack-Material-Regular.sfd"
modified_hack_material_bold="Modified-Hack-Material-Bold.sfd"

modified_hack_box_drawing_lights_generator="modified_hack_box_drawing_lights_generator.pe"
modified_hack_box_drawing_lights_regular="Modified-Hack-Box-Drawing-Lights-Regular.sfd"
modified_hack_box_drawing_lights_bold="Modified-Hack-Box-Drawing-Lights-Bold.sfd"

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

hackgen_generator="hackgen_generator.pe"
hackgen_console_generator="hackgen_console_generator.pe"
hackgen_box_drawing_lights_generator="hackgen_box_drawing_lights_generator.pe"

hackgen35_generator="hackgen35_generator.pe"
hackgen35_console_generator="hackgen35_console_generator.pe"

# hackgen_discord_generator="hackgen_discord_generator.pe"

regular2oblique_converter="regular2oblique_converter.sh"

# Get input fonts
tmp=""
for i in $fonts_directories
do
    [ -d "${i}" ] && tmp="${tmp} ${i}"
done
fonts_directories="${tmp}"
# Search Hack
input_hack_regular=`find $fonts_directories -follow -name Hack-Regular.ttf | head -n 1`
input_hack_bold=`find $fonts_directories -follow -name Hack-Bold.ttf | head -n 1`

if [ -z "${input_hack_regular}" -o -z "${input_hack_bold}" ]
then
  echo "Error: Hack-Regular.ttf and/or Hack-Bold.ttf not found" >&2
  exit 1
fi
# Search GenJyuuGothicL
input_genjyuu_regular=`find $fonts_directories -follow -iname GenJyuuGothicL-Monospace-Regular.ttf | head -n 1`
input_genjyuu_bold=`find $fonts_directories -follow -iname GenJyuuGothicL-Monospace-Bold.ttf    | head -n 1`
if [ -z "${input_genjyuu_regular}" -o -z "${input_genjyuu_bold}" ]
then
  echo "Error: GenJyuuGothicL-Monospace-regular.ttf and/or GenJyuuGothicL-Monospace-bold.ttf not found" >&2
  exit 1
fi

input_papipupepo_regular=`find $fonts_directories -follow -iname papipupepo-Regular.sfd | head -n 1`
input_papipupepo_bold=`find $fonts_directories -follow -iname papipupepo-Bold.sfd    | head -n 1`

input_chouon_ichi_regular=`find $fonts_directories -follow -iname chouon-ichi-Regular.sfd | head -n 1`
input_chouon_ichi_bold=`find $fonts_directories -follow -iname chouon-ichi-Bold.sfd    | head -n 1`

# Check filename
[ "$(basename $input_hack_regular)" != "Hack-Regular.ttf" ] &&
  echo "Warning: ${input_hack_regular} does not seem to be Hack Regular" >&2
[ "$(basename $input_hack_bold)" != "Hack-Bold.ttf" ] &&
  echo "Warning: ${input_hack_regular} does not seem to be Hack Bold" >&2
[ "$(basename $input_genjyuu_regular)" != "GenJyuuGothicL-Monospace-regular.ttf" ] &&
  echo "Warning: ${input_genjyuu_regular} does not seem to be GenJyuuGothicL Regular" >&2
[ "$(basename $input_genjyuu_bold)" != "GenJyuuGothicL-Monospace-bold.ttf" ] &&
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

########################################
# Generate script for modified Hack Material
########################################

cat > ${tmpdir}/${modified_hack_material_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified Hack Material")

# Set parameters
input_list  = ["${input_hack_regular}",    "${input_hack_bold}"]
output_list = ["${modified_hack_material_regular}", "${modified_hack_material_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  # パイプの破断線化
  Select(0u00a6); Copy()
  Select(0u007c); Paste()
  Scale(100, 114)

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
  Scale(109, 106)

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

  # クォーテーションの拡大
  Select(0u0027)
  SelectMore(0u0022)
  SelectMore(0u0060)
  Scale(108, 104)

  # Eclipse Pleiades 半角スペース記号 (U+1d1c) 対策
  Select(0u054d); Copy()
  Select(0u1d1c); Paste()
  Scale(85, 60)

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

select_box_drawing_lights='
  Select(0u2500, 0u259f)
'

########################################
# Generate script for extracting Box Drawings Lights on Hack Console
########################################

cat > ${tmpdir}/${modified_hack_box_drawing_lights_generator} << _EOT_
#!$fontforge_command -script

Print("Generate Box Drawings Lights on Hack")

# Set parameters
input_list  = ["${input_hack_regular}",    "${input_hack_bold}"]
output_list = ["${modified_hack_box_drawing_lights_regular}", "${modified_hack_box_drawing_lights_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open Hack
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  Scale(${hack_shrink_x}, ${hack_shrink_y}, 0, 0)

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${hackgen_half_width} - ${hack_width} * ${hack_shrink_x} / 100) / 2)) # -8
  width_pt = ${hackgen_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # 罫線記号のみを残し、残りを削除
  ${select_box_drawing_lights}
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

  # 罫線記号の削除
  ${select_box_drawing_lights}
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

  ## 記号
  SelectMore(0u00bc, 0u0522)
  SelectMore(0u0E3F)
  SelectMore(0u2010, 0u2021)
  SelectMore(0u2024, 0u2026)
  SelectMore(0u202f, 0u204b)
  SelectMore(0u2070, 0u208e)
  SelectMore(0u20a0, 0u20b9)
  SelectMore(0u2116, 0u215f)
  SelectMore(0u2200, 0u2215)
  SelectMore(0u221a, 0u222d)

  ## 矢印
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

  ## ≒≠≡
  SelectMore(0u2252)
  SelectMore(0u2260)
  SelectMore(0u2261)

  ## 罫線、図形
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

  ## 可視化文字対策
  SelectFewer(0u2022)
  SelectFewer(0u00b7)
  SelectFewer(0u2024)
  SelectFewer(0u2219)
  SelectFewer(0u25d8)
  SelectFewer(0u25e6)

  ## 結合分音記号は全て Hack ベースにする
  SelectFewer(0u0300, 0u036f)

  ## 選択中の文字を削除
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

  ## 記号
  SelectMore(0u00bc, 0u0522)
  SelectMore(0u0E3F)
  SelectMore(0u2010, 0u2021)
  SelectMore(0u2024, 0u2026)
  SelectMore(0u202f, 0u204b)
  SelectMore(0u2070, 0u208e)
  SelectMore(0u20a0, 0u20b9)
  SelectMore(0u2116, 0u215f)
  SelectMore(0u2200, 0u2215)
  SelectMore(0u221a, 0u222d)

  ## 矢印
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

  ## ≒≠≡
  SelectMore(0u2252)
  SelectMore(0u2260)
  SelectMore(0u2261)

  ## 罫線、図形
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

  ## 可視化文字対策
  SelectFewer(0u2022)
  SelectFewer(0u00b7)
  SelectFewer(0u2024)
  SelectFewer(0u2219)
  SelectFewer(0u25d8)
  SelectFewer(0u25e6)

  ## 結合分音記号は全て Hack ベースにする
  SelectFewer(0u0300, 0u036f)

  ## 選択中の文字を削除
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
papipupepo_list  = ["${input_papipupepo_regular}",    "${input_papipupepo_bold}"]
chouon_ichi_list  = ["${input_chouon_ichi_regular}",    "${input_chouon_ichi_bold}"]
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
  Open(papipupepo_list[i])
  MergeFonts(chouon_ichi_list[i])
  MergeFonts(input_list[i])

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

  # Edit zenkaku space (from ballot box and heavy greek cross)
  if ("${zenkaku_space_glyph}" != "0u3000")
        Print("Edit zenkaku space")
        if ("${zenkaku_space_glyph}" == "")
            Select(0u2610); Copy(); Select(0u3000); Paste()
            Select(0u271a); Copy(); Select(0u3000); PasteInto()
            OverlapIntersect()
        else
            Select(${zenkaku_space_glyph}); Copy(); Select(0u3000); Paste()
        endif
  endif

  # 結合分音記号は全て Hack ベースにする
  Select(0u0300, 0u036f); Clear()

  # Edit zenkaku brackets
  Print("Edit zenkaku brackets")
  bracket_move = $((${hackgen_half_width} / 2 + ${hackgen_half_width} / 30))
  Select(0uff08); Move(-bracket_move, 0); SetWidth(${hackgen_full_width}) # (
  Select(0uff09); Move( bracket_move, 0); SetWidth(${hackgen_full_width}) # )
  Select(0uff3b); Move(-bracket_move, 0); SetWidth(${hackgen_full_width}) # [
  Select(0uff3d); Move( bracket_move, 0); SetWidth(${hackgen_full_width}) # ]
  Select(0uff5b); Move(-bracket_move, 0); SetWidth(${hackgen_full_width}) # {
  Select(0uff5d); Move( bracket_move, 0); SetWidth(${hackgen_full_width}) # }

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
papipupepo_list  = ["${input_papipupepo_regular}",    "${input_papipupepo_bold}"]
chouon_ichi_list  = ["${input_chouon_ichi_regular}",    "${input_chouon_ichi_bold}"]
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
  Open(papipupepo_list[i])
  MergeFonts(chouon_ichi_list[i])
  MergeFonts(input_list[i])
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

  # Edit zenkaku space (from ballot box and heavy greek cross)
  if ("${zenkaku_space_glyph}" != "0u3000")
        Print("Edit zenkaku space")
        if ("${zenkaku_space_glyph}" == "")
            Select(0u2610); Copy(); Select(0u3000); Paste()
            Select(0u271a); Copy(); Select(0u3000); PasteInto()
            OverlapIntersect()
        else
            Select(${zenkaku_space_glyph}); Copy(); Select(0u3000); Paste()
        endif
  endif

  # 結合分音記号は全て Hack ベースにする
  Select(0u0300, 0u036f); Clear()

  # Edit zenkaku brackets
  Print("Edit zenkaku brackets")
  bracket_move = $((${hackgen35_half_width} / 2 + ${hackgen35_half_width} / 30))
  Select(0uff08); Move(-bracket_move, 0); SetWidth(${hackgen35_full_width}) # (
  Select(0uff09); Move( bracket_move, 0); SetWidth(${hackgen35_full_width}) # )
  Select(0uff3b); Move(-bracket_move, 0); SetWidth(${hackgen35_full_width}) # [
  Select(0uff3d); Move( bracket_move, 0); SetWidth(${hackgen35_full_width}) # ]
  Select(0uff5b); Move(-bracket_move, 0); SetWidth(${hackgen35_full_width}) # {
  Select(0uff5d); Move( bracket_move, 0); SetWidth(${hackgen35_full_width}) # }

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
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

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
  while ( ii < end_genjyuu )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii) && hack_exist_glyph_array[ii] == 1)
        Select(ii)
        Clear()
      endif
      ii = ii + 1
  endloop
  Print("End delete the glyphs contained in Hack")

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
  while ( ii < end_genjyuu )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii) && hack_exist_glyph_array[ii] == 1)
        Select(ii)
        Clear()
      endif
      ii = ii + 1
  endloop
  Print("End delete the glyphs contained in Hack")

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
copyright         = "Copyright (c) 2019, Yuko Otawara"
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
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for Box Drawing Lights for HackGen Console
########################################

cat > ${tmpdir}/${hackgen_box_drawing_lights_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate Box Drawing Lights for HackGen Console")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack_box_drawing_lights_regular}", \\
                     "${tmpdir}/${modified_hack_box_drawing_lights_bold}"]
fontfamily        = "${hackgen_familyname}"
fontfamilysuffix  = "${hackgen_box_drawing_lights_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "Copyright (c) 2019, Yuko Otawara"
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
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
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
copyright         = "Copyright (c) 2019, Yuko Otawara"
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
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
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
Print("Generate HackGen")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack35_regular}", \\
                     "${tmpdir}/${modified_hack35_bold}"]
fontfamily        = "${hackgen35_familyname}"
fontfamilysuffix  = "${hackgen35_familyname_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "Copyright (c) 2019, Yuko Otawara"
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
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
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
Print("Generate HackGen Console")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack35_console_regular}", \\
                     "${tmpdir}/${modified_hack35_console_bold}"]
fontfamily        = "${hackgen35_familyname}"
fontfamilysuffix  = "${hackgen_console_suffix}"
fontstyle_list    = ["Regular", "Bold"]
fontweight_list   = [400,       700]
panoseweight_list = [5,         8]
copyright         = "Copyright (c) 2019, Yuko Otawara"
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
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge Hack font
  Print("Merge " + hack_list[i]:t)
  MergeFonts(hack_list[i])

  # Save HackGen
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "")
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

# Generate Hack Box Drawing Lights for Console
$fontforge_command -script ${tmpdir}/${modified_hack_box_drawing_lights_generator} 2> $redirection_stderr || exit 4

# Generate Console
$fontforge_command -script ${tmpdir}/${modified_hack_console_generator} 2> $redirection_stderr || exit 4

# Generate Modiifed Hack
$fontforge_command -script ${tmpdir}/${modified_hack_generator} 2> $redirection_stderr || exit 4

# Generate Modified GenJyuu
$fontforge_command -script ${tmpdir}/${modified_genjyuu_generator} 2> $redirection_stderr || exit 4

# Generate Modified GenJyuu Console
$fontforge_command -script ${tmpdir}/${modified_genjyuu_console_generator} 2> $redirection_stderr || exit 4

# Generate HackGen
$fontforge_command -script ${tmpdir}/${hackgen_generator} 2> $redirection_stderr || exit 4

# Generate Box Drawing Lights for HackGen Console
$fontforge_command -script ${tmpdir}/${hackgen_box_drawing_lights_generator} 2> $redirection_stderr || exit 4

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
    pyftmerge "hinted_${hackgen_familyname}-${style}.ttf" "${tmpdir}/${modified_genjyuu_regular}.ttf"
    mv merged.ttf "${hackgen_familyname}-${style}.ttf"

    pyftmerge "hinted_${hackgen_familyname}${hackgen_console_suffix}-${style}.ttf" "${tmpdir}/${modified_genjyuu_console_regular}.ttf"
    pyftmerge merged.ttf "${hackgen_familyname}${hackgen_box_drawing_lights_suffix}-${style}.ttf" && rm "${hackgen_familyname}${hackgen_box_drawing_lights_suffix}-${style}.ttf"
    mv merged.ttf "${hackgen_familyname}${hackgen_console_suffix}-${style}.ttf"

    pyftmerge "hinted_${hackgen35_familyname}-${style}.ttf" "${tmpdir}/${modified_genjyuu35_regular}.ttf"
    mv merged.ttf "${hackgen35_familyname}-${style}.ttf"

    pyftmerge "hinted_${hackgen35_familyname}${hackgen_console_suffix}-${style}.ttf" "${tmpdir}/${modified_genjyuu35_console_regular}.ttf"
    mv merged.ttf "${hackgen35_familyname}${hackgen_console_suffix}-${style}.ttf"
  fi
  if [ "${style}" = 'Bold' ]; then
    pyftmerge "hinted_${hackgen_familyname}-${style}.ttf" "${tmpdir}/${modified_genjyuu_bold}.ttf"
    mv merged.ttf "${hackgen_familyname}-${style}.ttf"

    pyftmerge "hinted_${hackgen_familyname}${hackgen_console_suffix}-${style}.ttf" "${tmpdir}/${modified_genjyuu_console_bold}.ttf"
    pyftmerge merged.ttf "${hackgen_familyname}${hackgen_box_drawing_lights_suffix}-${style}.ttf" && rm "${hackgen_familyname}${hackgen_box_drawing_lights_suffix}-${style}.ttf"
    mv merged.ttf "${hackgen_familyname}${hackgen_console_suffix}-${style}.ttf"

    pyftmerge "hinted_${hackgen35_familyname}-${style}.ttf" "${tmpdir}/${modified_genjyuu35_bold}.ttf"
    mv merged.ttf "${hackgen35_familyname}-${style}.ttf"

    pyftmerge "hinted_${hackgen35_familyname}${hackgen_console_suffix}-${style}.ttf" "${tmpdir}/${modified_genjyuu35_console_bold}.ttf"
    mv merged.ttf "${hackgen35_familyname}${hackgen_console_suffix}-${style}.ttf"
  fi
done
rm -f hinted_*.ttf

# powerline patch
for style in Regular Bold
do
  $fontforge_command -lang=py -script "${powerline_patch_path}" "${hackgen_familyname}${hackgen_console_suffix}-${style}.ttf"
  mv "${hackgen_familyname} ${hackgen_console_suffix} ${style} for Powerline.ttf" "${hackgen_familyname}${hackgen_console_suffix}-${style}-forPowerline.ttf"

  $fontforge_command -lang=py -script "${powerline_patch_path}" "${hackgen35_familyname}${hackgen_console_suffix}-${style}.ttf"
  mv "${hackgen35_familyname} ${hackgen_console_suffix} ${style} for Powerline.ttf" "${hackgen35_familyname}${hackgen_console_suffix}-${style}-forPowerline.ttf"
done

# Remove temporary directory
if [ "${leaving_tmp_flag}" = "false" ]
then
  echo "Remove temporary files"
  rm -rf $tmpdir
fi

# Exit
echo "Succeeded in generating HackGen!"
exit 0
