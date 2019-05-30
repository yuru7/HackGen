#!/bin/sh

base_dir=$(cd $(dirname $0); pwd)
# HackGen Generator
hackgen_version="0.6.3"

# Set familyname
hackgen_familyname="HackGen"
hackgen_familyname_suffix=""
hackgen53_familyname="HackGen53"
hackgen53_familyname_suffix=""
hackgen_console_suffix="Console"

# Set ascent and descent (line width parameters)
hackgen_ascent=951
hackgen_descent=253

em_ascent=881
em_descent=143
em=$(($em_ascent + $em_descent))

typo_line_gap=100

hack_width=616
genjyuu_width=1024

hackgen_half_width=539
hackgen_full_width=$((${hackgen_half_width} * 2))

hackgen53_half_width=618
hackgen53_full_width=$((${hackgen53_half_width} * 5 / 3))

# Set path to fontforge command
fontforge_command="fontforge"
powerline_patch_path="${base_dir}/fontpatcher-develop/scripts/powerline-fontpatcher"

# Set redirection of stderr
redirection_stderr="/dev/null"

# Set fonts directories used in auto flag
fonts_directories=". ${HOME}/.fonts /usr/local/share/fonts /usr/share/fonts ${HOME}/Library/Fonts /Library/Fonts /c/Windows/Fonts /cygdrive/c/Windows/Fonts"

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

modified_hack_console_generator="modified_hack_console_generator.pe"
modified_hack_console_regular="Modified-Hack-Console-Regular.sfd"
modified_hack_console_bold="Modified-Hack-Console-Bold.sfd"

modified_hack53_console_generator="modified_hack53_console_generator.pe"
modified_hack53_console_regular="Modified-Hack53-Console-Regular.sfd"
modified_hack53_console_bold="Modified-Hack53-Console-Bold.sfd"

modified_hack_generator="modified_hack_generator.pe"
modified_hack_regular="Modified-Hack-Regular.sfd"
modified_hack_bold="Modified-Hack-Bold.sfd"

modified_hack53_generator="modified_hack53_generator.pe"
modified_hack53_regular="Modified-Hack53-Regular.sfd"
modified_hack53_bold="Modified-Hack53-Bold.sfd"

modified_genjyuu_generator="modified_genjyuu_generator.pe"
modified_genjyuu_regular="Modified-GenJyuuGothicL-Monospace-regular.sfd"
modified_genjyuu_bold="Modified-GenJyuuGothicL-Monospace-bold.sfd"

modified_genjyuu53_generator="modified_genjyuu53_generator.pe"
modified_genjyuu53_regular="Modified-GenJyuuGothicL53-Monospace-regular.sfd"
modified_genjyuu53_bold="Modified-GenJyuuGothicL53-Monospace-bold.sfd"

hackgen_generator="hackgen_generator.pe"
hackgen_console_generator="hackgen_console_generator.pe"

hackgen53_generator="hackgen53_generator.pe"
hackgen53_console_generator="hackgen53_console_generator.pe"

# hackgen_discord_generator="hackgen_discord_generator.pe"

regular2oblique_converter="regular2oblique_converter.sh"

########################################
# Pre-process
########################################

# Define displaying help function
hackgen_generator_help()
{
    echo "Usage: hackgen_generator.sh [options] auto"
    echo "       hackgen_generator.sh [options] Hack-{Regular,Bold}.ttf GenJyuuGothicL-Monospace-{regular,bold}.ttf"
    echo ""
    echo "Options:"
    echo "  -h                     Display this information"
    echo "  -V                     Display version number"
    echo "  -f /path/to/fontforge  Set path to fontforge command"
    echo "  -v                     Enable verbose mode (display fontforge's warning)"
    echo "  -l                     Leave (do NOT remove) temporary files"
    echo "  -n string              Set fontfamily suffix (\"HackGen string\")"
    echo "  -w                     Widen line space"
    echo "  -W                     Widen line space extremely"
    echo "  -Z unicode             Set visible zenkaku space copied from another glyph"
    echo "  -z                     Disable visible zenkaku space"
    echo "  -a                     Disable fullwidth ambiguous charactors"
    echo "  -s                     Disable scaling down GenJyuuGothicL"
    echo "  -d characters          Set non-Discorded characters in HackGen Discord"
    exit 0
}

# Get options
while getopts hVf:vln:wWbBZ:zasd: OPT
do
    case "${OPT}" in
        "h" )
            hackgen_generator_help
            ;;
        "V" )
            exit 0
            ;;
        "f" )
            echo "Option: Set path to fontforge command: ${OPTARG}"
            fontforge_command="${OPTARG}"
            ;;
        "v" )
            echo "Option: Enable verbose mode"
            redirection_stderr="/dev/stderr"
            ;;
        "l" )
            echo "Option: Leave (do NOT remove) temporary files"
            leaving_tmp_flag="true"
            ;;
        "n" )
            echo "Option: Set fontfamily suffix: ${OPTARG}"
            hackgen_familyname_suffix=`echo $OPTARG | tr -d ' '`
            ;;
        "w" )
            echo "Option: Widen line space"
            hackgen_ascent=`expr $hackgen_ascent + 128`
            hackgen_descent=`expr $hackgen_descent + 32`
            ;;
        "W" )
            echo "Option: Widen line space extremely"
            hackgen_ascent=`expr $hackgen_ascent + 256`
            hackgen_descent=`expr $hackgen_descent + 64`
            ;;
        "Z" )
            echo "Option: Set visible zenkaku space copied from another glyph: ${OPTARG}"
            zenkaku_space_glyph="0u${OPTARG}"
            ;;
        "z" )
            echo "Option: Disable visible zenkaku space"
            zenkaku_space_glyph="0u3000"
            ;;
        "a" )
            echo "Option: Disable fullwidth ambiguous charactors"
            fullwidth_ambiguous_flag="false"
            ;;
        "s" )
            echo "Option: Disable scaling down GenJyuuGothicL"
            scaling_down_flag="false"
            ;;
        "d" )
            echo "Option: Set non-Discorded characters in HackGen Discord: ${OPTARG}"
            non_discorded_characters="${OPTARG}"
            ;;
        * )
            exit 1
            ;;
    esac
done
shift `expr $OPTIND - 1`

# Get input fonts
if [ $# -eq 1 -a "$1" = "auto" ]
then
    # Check existance of directories
    tmp=""
    for i in $fonts_directories
    do
        [ -d "${i}" ] && tmp="${tmp} ${i}"
    done
    fonts_directories=$tmp
    # Search Hack
    # input_hack_regular=`find $fonts_directories -follow -name Hack-Regular.sfd | head -n 1`
    # input_hack_bold=`find $fonts_directories -follow -name Hack-Bold.sfd | head -n 1`
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
elif [ $# -eq 4 ]
then
    # Get arguments
    input_hack_regular=$1
    input_hack_bold=$2
    input_genjyuu_regular=$3
    input_genjyuu_bold=$4
    # Check existance of files
    if [ ! -r "${input_hack_regular}" ]
    then
        echo "Error: ${input_hack_regular} not found" >&2
        exit 1
    elif [ ! -r "${input_hack_bold}" ]
    then
        echo "Error: ${input_hack_bold} not found" >&2
        exit 1
    elif [ ! -r "${input_genjyuu_regular}" ]
    then
        echo "Error: ${input_genjyuu_regular} not found" >&2
        exit 1
    elif [ ! -r "${input_genjyuu_bold}" ]
    then
        echo "Error: ${input_genjyuu_bold} not found" >&2
        exit 1
    fi
    # Check filename
    [ "$(basename $input_hack_regular)" != "Hack-Regular.ttf" ] &&
        echo "Warning: ${input_hack_regular} does not seem to be Hack Regular" >&2
    [ "$(basename $input_hack_bold)" != "Hack-Bold.ttf" ] &&
        echo "Warning: ${input_hack_regular} does not seem to be Hack Bold" >&2
    [ "$(basename $input_genjyuu_regular)" != "GenJyuuGothicL-Monospace-regular.ttf" ] &&
        echo "Warning: ${input_genjyuu_regular} does not seem to be GenJyuuGothicL Regular" >&2
    [ "$(basename $input_genjyuu_bold)" != "GenJyuuGothicL-Monospace-bold.ttf" ] &&
        echo "Warning: ${input_genjyuu_bold} does not seem to be GenJyuuGothicL Bold" >&2
else
    hackgen_generator_help
fi

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
    Select(0u0030); Paste(); Scale(97, 100)
    Select(0u00b7); Copy()
    Select(0ufff0); Paste(); Scale(80, 130); Copy()
    Select(0u0030); PasteInto()
    Select(0ufff0); Clear()

    # クォーテーションの拡大
    Select(0u0022)
    SelectMore(0u0027)
    SelectMore(0u0060)
    Scale(110, 105)

    # ; : , . の拡大
    Select(0u003a)
    SelectMore(0u003b)
    SelectMore(0u002c)
    SelectMore(0u002e)
    Scale(108)

    # クォーテーションの拡大
    Select(0u0027)
    SelectMore(0u0022)
    SelectMore(0u0060)
    Scale(108, 104)

    # Eclipse Pleiades 半角スペース記号 (u+054d) 対策
    Select(0u054d); Copy()
    Select(0u1d1c); Paste()
    Scale(100, 60)

    # パスの小数点以下を切り捨て
    SelectWorthOutputting()
    Simplify()
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

    Scale(90, 94, 0, 0)

    # 幅の変更 (Move で文字幅も変わることに注意)
    move_pt = $(((${hackgen_half_width} - ${hack_width}) / 2)) # -8
    width_pt = ${hackgen_half_width}
    Move(move_pt, 0)
    SetWidth(width_pt, 0)

    # パスの小数点以下を切り捨て
    SelectWorthOutputting()
    Simplify()
    RoundToInt()

    # Save modified Hack
    Print("Save " + output_list[i])
    Save("${tmpdir}/" + output_list[i])

    i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified Hack53 console
########################################

cat > ${tmpdir}/${modified_hack53_console_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified Hack53 Console")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack_material_regular}", "${tmpdir}/${modified_hack_material_bold}"]
output_list = ["${modified_hack53_console_regular}", "${modified_hack53_console_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
    # Open Hack
    Print("Open " + input_list[i])
    Open(input_list[i])
    SelectWorthOutputting()
    UnlinkReference()

    # 幅の変更 (Move で文字幅も変わることに注意)
    move_pt = $(((${hackgen53_half_width} - ${hack_width}) / 2)) # -8
    width_pt = ${hackgen53_half_width}
    Move(move_pt, 0)
    SetWidth(width_pt, 0)

    # パスの小数点以下を切り捨て
    SelectWorthOutputting()
    Simplify()
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
# Generate script for modified Hack53
########################################

cat > ${tmpdir}/${modified_hack53_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified Hack")

# Set parameters
input_list  = ["${tmpdir}/${modified_hack53_console_regular}", "${tmpdir}/${modified_hack53_console_bold}"]
output_list = ["${modified_hack53_regular}", "${modified_hack53_bold}"]

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
input_list  = ["${input_genjyuu_regular}",    "${input_genjyuu_bold}"]
output_list = ["${modified_genjyuu_regular}", "${modified_genjyuu_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
    # Open GenJyuuGothicL
    Print("Open " + input_list[i])
    Open(input_list[i])
    SelectWorthOutputting()
    UnlinkReference()
    ScaleToEm(${em_ascent}, ${em_descent})

    ii = 0
    end_genjyuu = 65535
    halfwidth_array = Array(end_genjyuu)
    i_halfwidth = 0
    Print("Half width check loop start")    
    while ( ii <= end_genjyuu )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii))
        Select(ii)
        if (GlyphInfo("Width")<768)
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
    width_pt = ${hackgen_half_width} # 538
    ii=0
    while (ii < i_halfwidth)
      SelectMore(halfwidth_array[ii])
      ii = ii + 1
    endloop
    Move(move_pt, 0)
    SetWidth(width_pt)
    Print("Half SetWidth end")
        
    # Save modified GenJyuuGothicL
    Print("Save " + output_list[i])
    Save("${tmpdir}/" + output_list[i])
    Close()

    i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified GenJyuuGothicL for HackGen53
########################################

cat > ${tmpdir}/${modified_genjyuu53_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified GenJyuuGothicL")

# Set parameters
input_list  = ["${input_genjyuu_regular}",    "${input_genjyuu_bold}"]
output_list = ["${modified_genjyuu53_regular}", "${modified_genjyuu53_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
    # Open GenJyuuGothicL
    Print("Open " + input_list[i])
    Open(input_list[i])
    SelectWorthOutputting()
    UnlinkReference()
    ScaleToEm(${em_ascent}, ${em_descent})

    ii = 0
    end_genjyuu = 65535
    halfwidth_array = Array(end_genjyuu)
    i_halfwidth = 0
    Print("Half width check loop start")    
    while ( ii <= end_genjyuu )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii))
        Select(ii)
        if (GlyphInfo("Width")<768)
          halfwidth_array[i_halfwidth] = ii
          i_halfwidth = i_halfwidth + 1
        endif
      endif
      ii = ii + 1
    endloop
    Print("Half width check loop end")    
    
    Print("Full SetWidth start")
    move_pt = $(((${hackgen53_full_width} - ${genjyuu_width}) / 2)) # 3
    width_pt = ${hackgen53_full_width} # 1030
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
    move_pt = $(((${hackgen53_half_width} - ${genjyuu_width} / 2) / 2)) # 53
    width_pt = ${hackgen53_half_width} # 618
    ii=0
    while (ii < i_halfwidth)
      SelectMore(halfwidth_array[ii])
      ii = ii + 1
    endloop
    Move(move_pt, 0)
    SetWidth(width_pt)
    Print("Half SetWidth end")
        
    # Save modified GenJyuuGothicL
    Print("Save " + output_list[i])
    Save("${tmpdir}/" + output_list[i])
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
genjyuu_list       = ["${tmpdir}/${modified_genjyuu_regular}", \\
                     "${tmpdir}/${modified_genjyuu_bold}"]
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

    # Merge Hack with GenJyuuGothicL
    Print("Merge " + hack_list[i]:t \\
          + " with " + genjyuu_list[i]:t)
    MergeFonts(hack_list[i])
    MergeFonts(genjyuu_list[i])

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

    # Save HackGen
    if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        #Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "", 4)
    else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        #Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "", 4)
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
genjyuu_list       = ["${tmpdir}/${modified_genjyuu_regular}", \\
                     "${tmpdir}/${modified_genjyuu_bold}"]
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

    # Merge Hack with GenJyuuGothicL
    Print("Merge " + hack_list[i]:t \\
          + " with " + genjyuu_list[i]:t)
    MergeFonts(hack_list[i])
    MergeFonts(genjyuu_list[i])

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

    # Save HackGen
    if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        #Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "", 4)
    else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        #Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "", 4)
    endif
    Close()

    i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for HackGen53
########################################

cat > ${tmpdir}/${hackgen53_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate HackGen")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack53_regular}", \\
                     "${tmpdir}/${modified_hack53_bold}"]
genjyuu_list       = ["${tmpdir}/${modified_genjyuu53_regular}", \\
                     "${tmpdir}/${modified_genjyuu53_bold}"]
fontfamily        = "${hackgen53_familyname}"
fontfamilysuffix  = "${hackgen53_familyname_suffix}"
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

    # Merge Hack with GenJyuuGothicL
    Print("Merge " + hack_list[i]:t \\
          + " with " + genjyuu_list[i]:t)
    MergeFonts(hack_list[i])
    MergeFonts(genjyuu_list[i])

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

    # Save HackGen
    if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        #Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "", 4)
    else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        #Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "", 4)
    endif
    Close()

    i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for HackGen53 Console
########################################

cat > ${tmpdir}/${hackgen53_console_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate HackGen Console")

# Set parameters
hack_list  = ["${tmpdir}/${modified_hack53_console_regular}", \\
                     "${tmpdir}/${modified_hack53_console_bold}"]
genjyuu_list       = ["${tmpdir}/${modified_genjyuu53_regular}", \\
                     "${tmpdir}/${modified_genjyuu53_bold}"]
fontfamily        = "${hackgen53_familyname}"
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

    # Merge Hack with GenJyuuGothicL
    Print("Merge " + hack_list[i]:t \\
          + " with " + genjyuu_list[i]:t)
    MergeFonts(hack_list[i])
    MergeFonts(genjyuu_list[i])

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

    # Save HackGen
    if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        #Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "", 4)
    else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        #Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "", 4)
    endif
    Close()

    i += 1
endloop

Quit()
_EOT_

########################################
# Generate script to convert regular style to oblique style
########################################

cat > ${tmpdir}/${regular2oblique_converter} << _EOT_
#!$fontforge_command -script

usage = "Usage: regular2oblique_converter.pe fontfamily-fontstyle.ttf ..."

if (\$argc == 1)
    Print(usage)
    Quit()
endif

i = 1
while (i < \$argc)

input_ttf = \$argv[i]
input     = input_ttf:t:r
if (input_ttf:t:e != "ttf")
    Print(usage)
    Quit()
endif

Print("Generate oblique: " + input_ttf)

hypen_index = Strrstr(input, '-')
if (hypen_index == -1)
    Print(usage)
    Quit()
endif
input_family = Strsub(input, 0, hypen_index)
input_style  = Strsub(input, hypen_index + 1)

output_family = input_family

if (input_style == "Regular" || input_style == "Roman")
    output_style = "Oblique"
    style        = "Oblique"
else
    output_style = input_style + "Oblique"
    style        = input_style + " Oblique"
endif

Open(input_ttf)

Reencode("unicode")

SetFontNames(output_family + "-" + output_style, \
             \$familyname, \
             \$familyname + " " + style, \
             style)
SetTTFName(0x409, 2, style)
SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))

SelectWorthOutputting()

Transform(100, 0, 20, 100, 0, 0)

RoundToInt()
RemoveOverlap()
RoundToInt()

#Generate(output_family + "-" + output_style + ".ttf", "", 0x84)
Generate(output_family + "-" + output_style + ".ttf", "", 4)
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

# Generate HackGen
$fontforge_command -script ${tmpdir}/${hackgen_generator} 2> $redirection_stderr || exit 4

# Generate HackGen Console
$fontforge_command -script ${tmpdir}/${hackgen_console_generator} 2> $redirection_stderr || exit 4

# Generate Console - 53
$fontforge_command -script ${tmpdir}/${modified_hack53_console_generator} 2> $redirection_stderr || exit 4

# Generate Modiifed Hack - 53
$fontforge_command -script ${tmpdir}/${modified_hack53_generator} 2> $redirection_stderr || exit 4

# Generate Modified GenJyuu - 53
$fontforge_command -script ${tmpdir}/${modified_genjyuu53_generator} 2> $redirection_stderr || exit 4

# Generate HackGen - 53
$fontforge_command -script ${tmpdir}/${hackgen53_generator} 2> $redirection_stderr || exit 4

# Generate HackGen Console - 53
$fontforge_command -script ${tmpdir}/${hackgen53_console_generator} 2> $redirection_stderr || exit 4

## Generate Oblique Style
#$fontforge_command -script ${tmpdir}/${regular2oblique_converter} \
#  ${hackgen_familyname}${hackgen_familyname_suffix}-Regular.ttf \
#  2> $redirection_stderr || exit 4
#$fontforge_command -script ${tmpdir}/${regular2oblique_converter} \
#  ${hackgen_familyname}${hackgen_familyname_suffix}-Bold.ttf \
#  2> $redirection_stderr || exit 4

# powerline patch
for style in Regular Bold
do
  $fontforge_command -lang=py -script "${powerline_patch_path}" "${hackgen_familyname}${hackgen_console_suffix}-${style}.ttf"
  mv "${hackgen_familyname} ${hackgen_console_suffix} ${style} for Powerline.ttf" "${hackgen_familyname}${hackgen_console_suffix}-${style}-forPowerline.ttf"

  $fontforge_command -lang=py -script "${powerline_patch_path}" "${hackgen53_familyname}${hackgen_console_suffix}-${style}.ttf"
  mv "${hackgen53_familyname} ${hackgen_console_suffix} ${style} for Powerline.ttf" "${hackgen53_familyname}${hackgen_console_suffix}-${style}-forPowerline.ttf"

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

