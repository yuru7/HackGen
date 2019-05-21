#!/bin/sh

# HackGen Generator
hackgen_version="0.1.0"

# Set familyname
hackgen_familyname="HackGen"
hackgen_familyname_suffix=""

# Set ascent and descent (line width parameters)
hackgen_ascent=950
hackgen_descent=250

scaletoem_ascent=881
scaletoem_descent=143
em=$(($scaletoem_ascent + $scaletoem_descent))

# Set path to fontforge command
fontforge_command="fontforge"

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
modified_hack_generator="modified_hack_generator.pe"
modified_hack_regular="Modified-Hack-Regular.sfd"
modified_hack_bold="Modified-Hack-Bold.sfd"
modified_genjyuu_generator="modified_genjyuu_generator.pe"
modified_genjyuu_regular="Modified-GenJyuuGothicL-Monospace-regular.sfd"
modified_genjyuu_bold="Modified-GenJyuuGothicL-Monospace-bold.sfd"
hackgen_generator="hackgen_generator.pe"
hackgen_discord_generator="hackgen_discord_generator.pe"
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
    input_hack_regular=`find $fonts_directories -follow -name Hack-Regular.sfd | head -n 1`
    input_hack_bold=`find $fonts_directories -follow -name Hack-Bold.sfd | head -n 1`
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
# Generate script for modified Hack
########################################

cat > ${tmpdir}/${modified_hack_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified Hack")

# Set parameters
input_list  = ["${input_hack_regular}",    "${input_hack_bold}"]
output_list = ["${modified_hack_regular}", "${modified_hack_bold}"]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
    # Open Hack
    Print("Open " + input_list[i])
    Open(input_list[i])
    SelectWorthOutputting()
    UnlinkReference()
    RoundToInt(100)
    #ScaleToEm(860, 140)
    #ScaleToEm(${scaletoem_ascent}, ${scaletoem_descent})

    # 下限よりも下にはみ出す文字対応
    #SelectWorthOutputting(); Move(0, 38)

    # brokenbar
    #Select(0u00a6); Copy()
    #Select(0u007c); Paste()
    #Move(0, 120)

    # _ のかすれ対応
    Select(0u005f); Move(0, 1)

    # 三角形・四角形・罫線記号を全角化
    #Select(0u2500, 0u25ff); Clear()
    # 矢印記号を全角化
    #Select(0u2100, 0u21ff); Clear()

    # Remove ambiguous glyphs
    if ("${fullwidth_ambiguous_flag}" == "true")
        Print("Remove ambiguous glyphs")
        Select(0u00a1); Clear()
        Select(0u00a4); Clear()
        Select(0u00a7); Clear()
        Select(0u00a8); Clear()
        Select(0u00aa); Clear()
        Select(0u00ad); Clear()
        Select(0u00ae); Clear()
        Select(0u00b0); Clear()
        Select(0u00b1); Clear()
        Select(0u00b2, 0u00b3); Clear()
        Select(0u00b4); Clear()
        Select(0u00b6, 0u00b7); Clear()
        Select(0u00b8); Clear()
        Select(0u00b9); Clear()
        Select(0u00ba); Clear()
        Select(0u00bc, 0u00be); Clear()
        Select(0u00bf); Clear()
        Select(0u00c6); Clear()
        Select(0u00d0); Clear()
        Select(0u00d7); Clear()
        Select(0u00d8); Clear()
        Select(0u00de, 0u00e1); Clear()
        Select(0u00e6); Clear()
        Select(0u00e8, 0u00ea); Clear()
        Select(0u00ec, 0u00ed); Clear()
        Select(0u00f0); Clear()
        Select(0u00f2, 0u00f3); Clear()
        Select(0u00f7); Clear()
        Select(0u00f8, 0u00fa); Clear()
        Select(0u00fc); Clear()
        Select(0u00fe); Clear()
        Select(0u0101); Clear()
        Select(0u0111); Clear()
        Select(0u0113); Clear()
        Select(0u011b); Clear()
        Select(0u0126, 0u0127); Clear()
        Select(0u012b); Clear()
        Select(0u0131, 0u0133); Clear()
        Select(0u0138); Clear()
        Select(0u013f, 0u0142); Clear()
        Select(0u0144); Clear()
        Select(0u0148, 0u014b); Clear()
        Select(0u014d); Clear()
        Select(0u0152, 0u0153); Clear()
        Select(0u0166, 0u0167); Clear()
        Select(0u016b); Clear()
        Select(0u01ce); Clear()
        Select(0u01d0); Clear()
        Select(0u01d2); Clear()
        Select(0u01d4); Clear()
        Select(0u01d6); Clear()
        Select(0u01d8); Clear()
        Select(0u01da); Clear()
        Select(0u01dc); Clear()
        Select(0u0251); Clear()
        Select(0u0261); Clear()
        Select(0u02c4); Clear()
        Select(0u02c7); Clear()
        Select(0u02c9, 0u02cb); Clear()
        Select(0u02cd); Clear()
        Select(0u02d0); Clear()
        Select(0u02d8, 0u02db); Clear()
        Select(0u02dd); Clear()
        Select(0u02df); Clear()
        Select(0u0300, 0u036f); Clear()
        Select(0u0391, 0u03a1); Clear()
        Select(0u03a3, 0u03a9); Clear()
        Select(0u03b1, 0u03c1); Clear()
        Select(0u03c3, 0u03c9); Clear()
        Select(0u0401); Clear()
        Select(0u0410, 0u044f); Clear()
        Select(0u0451); Clear()
        Select(0u2010); Clear()
        Select(0u2013, 0u2015); Clear()
        Select(0u2016); Clear()
        Select(0u2018); Clear()
        Select(0u2019); Clear()
        Select(0u201c); Clear()
        Select(0u201d); Clear()
        Select(0u2020, 0u2022); Clear()
        Select(0u2024, 0u2027); Clear()
        Select(0u2030); Clear()
        Select(0u2032, 0u2033); Clear()
        Select(0u2035); Clear()
        Select(0u203b); Clear()
        Select(0u203e); Clear()
        Select(0u2074); Clear()
        Select(0u207f); Clear()
        Select(0u2081, 0u2084); Clear()
        Select(0u20ac); Clear()
        Select(0u2103); Clear()
        Select(0u2105); Clear()
        Select(0u2109); Clear()
        Select(0u2113); Clear()
        Select(0u2116); Clear()
        Select(0u2121, 0u2122); Clear()
        Select(0u2126); Clear()
        Select(0u212b); Clear()
        Select(0u2153, 0u2154); Clear()
        Select(0u215b, 0u215e); Clear()
        Select(0u2160, 0u216b); Clear()
        Select(0u2170, 0u2179); Clear()
        Select(0u2189); Clear()
        Select(0u2190, 0u2194); Clear()
        Select(0u2195, 0u2199); Clear()
        Select(0u21b8, 0u21b9); Clear()
        Select(0u21d2); Clear()
        Select(0u21d4); Clear()
        Select(0u21e7); Clear()
        Select(0u2200); Clear()
        Select(0u2202, 0u2203); Clear()
        Select(0u2207, 0u2208); Clear()
        Select(0u220b); Clear()
        Select(0u220f); Clear()
        Select(0u2211); Clear()
        Select(0u2215); Clear()
        Select(0u221a); Clear()
        Select(0u221d, 0u2220); Clear()
        Select(0u2223); Clear()
        Select(0u2225); Clear()
        Select(0u2227, 0u222c); Clear()
        Select(0u222e); Clear()
        Select(0u2234, 0u2237); Clear()
        Select(0u223c, 0u223d); Clear()
        Select(0u2248); Clear()
        Select(0u224c); Clear()
        Select(0u2252); Clear()
        Select(0u2260, 0u2261); Clear()
        Select(0u2264, 0u2267); Clear()
        Select(0u226a, 0u226b); Clear()
        Select(0u226e, 0u226f); Clear()
        Select(0u2282, 0u2283); Clear()
        Select(0u2286, 0u2287); Clear()
        Select(0u2295); Clear()
        Select(0u2299); Clear()
        Select(0u22a5); Clear()
        Select(0u22bf); Clear()
        Select(0u2312); Clear()
        Select(0u2460, 0u249b); Clear()
        Select(0u249c, 0u24e9); Clear()
        Select(0u24eb, 0u24ff); Clear()
        Select(0u2500, 0u254b); Clear()
        Select(0u2550, 0u2573); Clear()
        Select(0u2580, 0u258f); Clear()
        Select(0u2592, 0u2595); Clear()
        Select(0u25a0, 0u25a1); Clear()
        Select(0u25a3, 0u25a9); Clear()
        Select(0u25b2, 0u25b3); Clear()
        Select(0u25b6); Clear()
        Select(0u25b7); Clear()
        Select(0u25bc, 0u25bd); Clear()
        Select(0u25c0); Clear()
        Select(0u25c1); Clear()
        Select(0u25c6, 0u25c8); Clear()
        Select(0u25cb); Clear()
        Select(0u25ce, 0u25d1); Clear()
        Select(0u25e2, 0u25e5); Clear()
        Select(0u25ef); Clear()
        Select(0u2605, 0u2606); Clear()
        Select(0u2609); Clear()
        Select(0u260e, 0u260f); Clear()
        Select(0u261c); Clear()
        Select(0u261e); Clear()
        Select(0u2640); Clear()
        Select(0u2642); Clear()
        Select(0u2660, 0u2661); Clear()
        Select(0u2663, 0u2665); Clear()
        Select(0u2667, 0u266a); Clear()
        Select(0u266c, 0u266d); Clear()
        Select(0u266f); Clear()
        Select(0u269e, 0u269f); Clear()
        Select(0u26bf); Clear()
        Select(0u26c6, 0u26cd); Clear()
        Select(0u26cf, 0u26d3); Clear()
        Select(0u26d5, 0u26e1); Clear()
        Select(0u26e3); Clear()
        Select(0u26e8, 0u26e9); Clear()
        Select(0u26eb, 0u26f1); Clear()
        Select(0u26f4); Clear()
        Select(0u26f6, 0u26f9); Clear()
        Select(0u26fb, 0u26fc); Clear()
        Select(0u26fe, 0u26ff); Clear()
        Select(0u273d); Clear()
        Select(0u2776, 0u277f); Clear()
        Select(0u2b56, 0u2b59); Clear()
        Select(0u3248, 0u324f); Clear()
        Select(0ue000, 0uf8ff); Clear()
        Select(0ufe00, 0ufe0f); Clear()
        Select(0ufffd); Clear()
    endif

    # Clear instructions
    #Print("Clear instructions")
    #SelectWorthOutputting()
    #ClearInstrs()
    #RoundToInt(); RemoveOverlap(); RoundToInt()        
    #AutoHint()
    #AutoInstr()

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
    #ScaleToEm(860, 140)
    #ScaleToEm(${scaletoem_ascent}, ${scaletoem_descent})

    SelectWorthOutputting()
    SetWidth(1064)
    Move(20, 0)

    # Scale down all glyphs
    #if ("${scaling_down_flag}" == "true")
    #    Print("Scale down all glyphs (it may take a few minutes)")
    #    SelectWorthOutputting()
    #    SetWidth(-1, 1); Scale(91, 91, 0, 0); SetWidth(110, 2); SetWidth(1, 1)
    #    Move(23, 0); SetWidth(-23, 1)
    #    RoundToInt(); RemoveOverlap(); RoundToInt()
    #endif

    # Clear instructions
    #Print("Clear instructions")
    #SelectWorthOutputting()
    #ClearInstrs()

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
#genjyuu_list       = ["${input_genjyuu_regular}", \\
#                     "${input_genjyuu_bold}"]
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
    #ScaleToEm(860, 140)
    #ScaleToEm(${scaletoem_ascent}, ${scaletoem_descent})
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
    SetOS2Value("TypoAscent",            860)
    SetOS2Value("TypoDescent",          -140)
    SetOS2Value("TypoLineGap",             0)
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

#    # Edit zenkaku comma and period
#    Print("Edit zenkaku comma and period")
#    #Select(0uff0c); Scale(150, 150, 100, 0); SetWidth(1000)
#    #Select(0uff0e); Scale(150, 150, 100, 0); SetWidth(1000)
#    Select(0uff0c); Scale(150, 150, $(printf '%.0f' $(echo "scale=1; $em * 0.1" | bc)), 0); SetWidth($em)
#    Select(0uff0e); Scale(150, 150, $(printf '%.0f' $(echo "scale=1; $em * 0.1" | bc)), 0); SetWidth($em)
#
#    # Edit zenkaku colon and semicolon
#    Print("Edit zenkaku colon and semicolon")
#    Select(0uff0c); Copy(); Select(0uff1b); Paste()
#    Select(0uff0e); Copy(); Select(0uff1b); PasteWithOffset(0, 400)
#    CenterInWidth()
#    Select(0uff1a); Paste(); PasteWithOffset(0, 400)
#    CenterInWidth()
#
#    # Edit zenkaku brackets
#    Print("Edit zenkaku brackets")
#    #Select(0u0028); Copy(); Select(0uff08); Paste(); Move(250, 0); SetWidth(1000) # (
#    #Select(0u0029); Copy(); Select(0uff09); Paste(); Move(250, 0); SetWidth(1000) # )
#    #Select(0u005b); Copy(); Select(0uff3b); Paste(); Move(250, 0); SetWidth(1000) # [
#    #Select(0u005d); Copy(); Select(0uff3d); Paste(); Move(250, 0); SetWidth(1000) # ]
#    #Select(0u007b); Copy(); Select(0uff5b); Paste(); Move(250, 0); SetWidth(1000) # {
#    #Select(0u007d); Copy(); Select(0uff5d); Paste(); Move(250, 0); SetWidth(1000) # }
#    #Select(0u003c); Copy(); Select(0uff1c); Paste(); Move(250, 0); SetWidth(1000) # <
#    #Select(0u003e); Copy(); Select(0uff1e); Paste(); Move(250, 0); SetWidth(1000) # >
#    Select(0u0028); Copy(); Select(0uff08); Paste(); Move($(($em / 4)), 0); SetWidth($em) # (
#    Select(0u0029); Copy(); Select(0uff09); Paste(); Move($(($em / 4)), 0); SetWidth($em) # )
#    Select(0u005b); Copy(); Select(0uff3b); Paste(); Move($(($em / 4)), 0); SetWidth($em) # [
#    Select(0u005d); Copy(); Select(0uff3d); Paste(); Move($(($em / 4)), 0); SetWidth($em) # ]
#    Select(0u007b); Copy(); Select(0uff5b); Paste(); Move($(($em / 4)), 0); SetWidth($em) # {
#    Select(0u007d); Copy(); Select(0uff5d); Paste(); Move($(($em / 4)), 0); SetWidth($em) # }
#    Select(0u003c); Copy(); Select(0uff1c); Paste(); Move($(($em / 4)), 0); SetWidth($em) # <
#    Select(0u003e); Copy(); Select(0uff1e); Paste(); Move($(($em / 4)), 0); SetWidth($em) # >

    # Edit en and em dashes
    Print("Edit en and em dashes")
    Select(0u2013); Copy()
    PasteWithOffset(200, 0); PasteWithOffset(-200, 0)
    OverlapIntersect()
    Select(0u2014); Copy()
    PasteWithOffset(490, 0); PasteWithOffset(-490, 0)
    OverlapIntersect()

    # Proccess before saving
    #Print("Process before saving (it may take a few minutes)")
    #Select(".notdef")
    #DetachAndRemoveGlyphs()
    #SelectWorthOutputting()
    #RoundToInt(); RemoveOverlap(); RoundToInt()
    #AutoHint()
    #AutoInstr()

    # Save HackGen
    if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf")
        Generate(fontfamily + fontfamilysuffix + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
    else
        Print("Save " + fontfamily + "-" + fontstyle_list[i] + ".ttf")
        Generate(fontfamily + "-" + fontstyle_list[i] + ".ttf", "", 0x84)
    endif
    Close()

    i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for HackGen Discord
########################################

cat > ${tmpdir}/${hackgen_discord_generator} << _EOT_
#!$fontforge_command -script

# Get arguments
if (\$argc != 3)
   Print("Usage: hackgen_discord_generator.pe filename.ttf characters")
   Quit()
endif
filename = \$argv[1]
characters = \$argv[2]

Print("Generate HackGen Discord")

# Enable all flags
flag_quotedbl="true"
flag_quotesingle="true"
flag_asterisk="true"
flag_plus="true"
flag_comma="true"
flag_hyphen="true"
flag_period="true"
flag_0="true"
flag_7="true"
flag_colon="true"
flag_semicolon="true"
flag_less_greater="true"
flag_equal="true"
flag_D="true"
flag_Z="true"
flag_asciicircum="true"
flag_grave="true"
flag_l="true"
flag_r="true"
flag_z="true"
flag_bar="true"
flag_asciitilde="true"

# Disable flags
if (Strstr(characters, '"') != -1)
    Print("Option: Disable magnified \"")
    flag_quotedbl="false"
endif
if (Strstr(characters, "'") != -1)
    Print("Option: Disable magnified \'")
    flag_quotesingle="false"
endif
if (Strstr(characters, "*") != -1)
    Print("Option: Disable * moved downward a little")
    flag_asterisk="false"
endif
if (Strstr(characters, "+") != -1)
    Print("Option: Disable + moved downward a little")
    flag_plus="false"
endif
if (Strstr(characters, ",") != -1)
    Print("Option: Disable magnified ,")
    flag_comma="false"
endif
if (Strstr(characters, "-") != -1)
    Print("Option: Disable - moved downward a little")
    flag_hyphen="false"
endif
if (Strstr(characters, ".") != -1)
    Print("Option: Disable magnified .")
    flag_period="false"
endif
if (Strstr(characters, "0") != -1)
    Print("Option: Disable dotted 0 (Hack's unused glyph)")
    flag_0="false"
endif
if (Strstr(characters, "7") != -1)
    Print("Option: Disable 7 with cross-bar")
    flag_7="false"
endif
if (Strstr(characters, ":") != -1)
    Print("Option: Disable magnified :")
    flag_colon="false"
endif
if (Strstr(characters, ";") != -1)
    Print("Option: Disable magnified ;")
    flag_semicolon="false"
endif
if (Strstr(characters, "<") != -1 || Strstr(characters, ">") != -1)
    Print("Option: Disable < and > moved downward a little")
    flag_less_greater="false"
endif
if (Strstr(characters, "=") != -1)
    Print("Option: Disable = moved downward a little")
    flag_equal="false"
endif
if (Strstr(characters, "D") != -1)
    Print("Option: Disable D of Eth (D with cross-bar)")
    flag_D="false"
endif
if (Strstr(characters, "Z") != -1)
    Print("Option: Disable Z with cross-bar")
    flag_Z="false"
endif
if (Strstr(characters, "^") != -1)
    Print("Option: Disable magnified ^")
    flag_asciicircum="false"
endif
if (Strstr(characters, "\`") != -1)
    Print("Option: Disable magnified \`")
    flag_grave="false"
endif
if (Strstr(characters, "l") != -1)
    Print("Option: Disable l of cutting off left-bottom serif")
    flag_l="false"
endif
if (Strstr(characters, "r") != -1)
    Print("Option: Disable r of serif (Hack's unused glyph)")
    flag_r="false"
endif
if (Strstr(characters, "z") != -1)
    Print("Option: Disable z with cross-bar")
    flag_z="false"
endif
if (Strstr(characters, "|") != -1)
    Print("Option: Disable broken |")
    flag_bar="false"
endif
if (Strstr(characters, "~") != -1)
    Print("Option: Disable ~ moved upward")
    flag_asciitilde="false"
endif

# Check filename
input = filename:t:r
hyphen_index = Strrstr(input, '-')
if (filename:e != "ttf" || hyphen_index == -1)
    Print("Invalid argument: " + filename)
    Quit()
endif
inputfamily  = Strsub(input, 0, hyphen_index)
inputstyle   = Strsub(input, hyphen_index + 1)
familysuffix = "Discord"

# Open file and set configuration
Open(filename)
Reencode("unicode")
SetFontNames(inputfamily + familysuffix + "-" + inputstyle, \
             \$familyname + " " + familysuffix, \
             \$familyname + " " + familysuffix + " " + inputstyle, \
             inputstyle)
SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))

# " -> magnified "
if (flag_quotedbl == "true")
    #Select(0u0022); Scale(115, 115, 250, 600); SetWidth(500)
    Select(0u0022); Scale(115, 115, $(($em / 4)), $(printf '%.0f' $(echo "scale=1; $em * 0.6" | bc))); SetWidth($(($em / 2)))
    RoundToInt(); RemoveOverlap(); RoundToInt()
endif

# ' -> magnified '
if (flag_quotesingle == "true")
    #Select(0u0027); Scale(115, 115, 250, 600); SetWidth(500)
    Select(0u0027); Scale(115, 115, $(($em / 4)), $(printf '%.0f' $(echo "scale=1; $em * 0.6" | bc))); SetWidth($(($em / 2)))
    RoundToInt(); RemoveOverlap(); RoundToInt()
endif

# * -> * moved downward a little
if (flag_asterisk == "true")
    Select(0u002a); Move(0, -80)
endif

# + -> + moved downward a little
if (flag_plus == "true")
    Select(0u002b); Move(0, -80)
endif

# , -> magnified ,
if (flag_comma == "true")
    #Select(0u002c); Scale(115, 115, 250, 0); SetWidth(500)
    Select(0u002c); Scale(115, 115, $(($em / 4)), 0); SetWidth($(($em / 2)))
    RoundToInt(); RemoveOverlap(); RoundToInt()
endif

# - -> - moved downward a little
if (flag_hyphen == "true")
    Select(0u002d); Move(0, -80)
endif

# . -> magnified .
if (flag_period == "true")
    #Select(0u002e); Scale(115, 115, 250, 0); SetWidth(500)
    Select(0u002e); Scale(115, 115, $(($em / 4)), 0); SetWidth($em / 2)
    RoundToInt(); RemoveOverlap(); RoundToInt()
endif

# 0 -> dotted 0 (Hack's unused glyph)
if (flag_0 == "true")
    Select(65544);  Copy()
    Select(0u0030); Paste()
endif

# 7 -> 7 with cross-bar
if (flag_7 == "true")
    Select(0u00af); Copy() # macron
    Select(0u0037); PasteWithOffset(20, -263)
    RoundToInt(); RemoveOverlap(); RoundToInt()
endif

# : -> magnified :
if (flag_colon == "true")
    #Select(0u003a); Scale(115, 115, 250, 0); SetWidth(500)
    Select(0u003a); Scale(115, 115, $(($em / 4)), 0); SetWidth($(($em / 2)))
    RoundToInt(); RemoveOverlap(); RoundToInt()
endif

# ; -> magnified ;
if (flag_semicolon == "true")
    #Select(0u003b); Scale(115, 115, 250, 0); SetWidth(500)
    Select(0u003b); Scale(115, 115, $(($em / 4)), 0); SetWidth($(($em / 2)))
    RoundToInt(); RemoveOverlap(); RoundToInt()
endif

# < and > -> < and > moved downward a little
if (flag_less_greater == "true")
    Select(0u003c); Move(0, -80)
    Select(0u003e); Move(0, -80)
endif

# = -> = moved downward a little
if (flag_equal == "true")
    Select(0u003d); Move(0, -80)
endif

# D -> D of Eth (D with cross-bar)
if (flag_D == "true")
    Select(0u0110); Copy()
    Select(0u0044); Paste()
endif

# Z -> Z with cross-bar
if (flag_Z == "true")
    Select(0u00af); Copy()  # macron
    Select(65552);  Paste() # Temporary glyph
    #Transform(100, -65, 0, 100, 0, -12000); SetWidth(500)
    Transform(100, -65, 0, 100, 0, -12000); SetWidth($(($em / 2)))
    Copy()
    Select(0u005a); PasteInto()
    RoundToInt(); RemoveOverlap(); RoundToInt()
    Select(65552);  Clear() # Temporary glyph
endif

# ^ -> magnified ^
if (flag_asciicircum == "true")
    #Select(0u005e); Scale(115, 115, 250, 600); SetWidth(500)
    Select(0u005e); Scale(115, 115, $(($em / 4)), $(printf '%.0f' $(echo "scale=1; $em * 0.6" | bc))); SetWidth($(($em / 2)))
    RoundToInt(); RemoveOverlap(); RoundToInt()
endif

# \` -> magnified \`
if (flag_grave == "true")
    #Select(0u0060); Scale(115, 115, 250, 600); SetWidth(500)
    Select(0u0060); Scale(115, 115, $(($em / 4)), $(printf '%.0f' $(echo "scale=1; $em * 0.6" | bc))); SetWidth($(($em / 2)))
    RoundToInt(); RemoveOverlap(); RoundToInt()
endif

# l -> l of cutting off left-bottom serif
if (flag_l == "true")
    Select(0u006c); Copy()
    #Rotate(180); Move(1, 0); SetWidth(500)
    Rotate(180); Move(1, 0); SetWidth($(($em / 2)))
    PasteInto(); OverlapIntersect()
endif

# r -> r of serif (Hack's unused glyph)
if (flag_r == "true")
    Select(65542);  Copy()
    Select(0u0072); Paste()
endif

# z -> z with cross-bar
if (flag_z == "true")
    Select(0u00af); Copy()  # macron
    Select(65552);  Paste() # Temporary glyph
    #Transform(75, -52, 0, 100, 5500, -23500); SetWidth(500)
    Transform(75, -52, 0, 100, 5500, -23500); SetWidth($(($em / 2)))
    Copy()
    Select(0u007a); PasteInto()
    RoundToInt(); RemoveOverlap(); RoundToInt()
    Select(65552);  Clear() # Temporary glyph
endif

# | -> broken |
if (flag_bar == "true")
    Select(0u00a6); Copy()
    Select(0u007c); Paste()
endif

# ~ -> ~ moved upward
if (flag_asciitilde == "true")
    Select(0u007e); Move(0, 120)
endif

# Save HackGen Discord
Print("Save " + inputfamily + familysuffix + "-" + inputstyle + ".ttf")
Generate(inputfamily + familysuffix + "-" + inputstyle + ".ttf", "", 0x84)
Close()

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

Generate(output_family + "-" + output_style + ".ttf", "", 0x84)
Close()

i += 1
endloop

Quit()
_EOT_

########################################
# Generate HackGen
########################################

# Generate HackGen
$fontforge_command -script ${tmpdir}/${modified_hack_generator} \
    2> $redirection_stderr || exit 4
$fontforge_command -script ${tmpdir}/${modified_genjyuu_generator} \
    2> $redirection_stderr || exit 4
$fontforge_command -script ${tmpdir}/${hackgen_generator} \
    2> $redirection_stderr || exit 4
#$fontforge_command -script ${tmpdir}/${hackgen_discord_generator} \
#    ${hackgen_familyname}${hackgen_familyname_suffix}-Regular.ttf "${non_discorded_characters}" \
#    2> $redirection_stderr || exit 4
#$fontforge_command -script ${tmpdir}/${hackgen_discord_generator} \
#    ${hackgen_familyname}${hackgen_familyname_suffix}-Bold.ttf "${non_discorded_characters}" \
#    2> $redirection_stderr || exit 4
$fontforge_command -script ${tmpdir}/${regular2oblique_converter} \
    ${hackgen_familyname}${hackgen_familyname_suffix}-Regular.ttf \
    2> $redirection_stderr || exit 4
$fontforge_command -script ${tmpdir}/${regular2oblique_converter} \
    ${hackgen_familyname}${hackgen_familyname_suffix}-Bold.ttf \
    2> $redirection_stderr || exit 4
#$fontforge_command -script ${tmpdir}/${regular2oblique_converter} \
#    ${hackgen_familyname}${hackgen_familyname_suffix}Discord-Regular.ttf \
#    2> $redirection_stderr || exit 4
#$fontforge_command -script ${tmpdir}/${regular2oblique_converter} \
#    ${hackgen_familyname}${hackgen_familyname_suffix}Discord-Bold.ttf \
#    2> $redirection_stderr || exit 4

# Remove temporary directory
if [ "${leaving_tmp_flag}" = "false" ]
then
    echo "Remove temporary files"
    rm -rf $tmpdir
fi

# Exit
echo "Succeeded in generating HackGen!"
exit 0

