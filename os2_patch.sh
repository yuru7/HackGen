#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)

xAvgCharWidth_SETVAL=1078
HACKGEN_PATTERN='HackGen[^5]*.ttf'

xAvgCharWidth53_SETVAL=1030
HACKGEN53_PATTERN='HackGen53*.ttf'

for P in ${BASE_DIR}/${HACKGEN_PATTERN}; do
  ttx -t OS/2 -t post "$P"

  xAvgCharWidth_value=$(grep xAvgCharWidth "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  sed -i.bak -e 's,xAvgCharWidth value="'$xAvgCharWidth_value'",xAvgCharWidth value="'${xAvgCharWidth_SETVAL}'",' "${P%%.ttf}.ttx"

  fsSelection_value=$(grep fsSelection "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  if [ `echo $P | grep Regular` ]; then
    fsSelection_sed_value='00000000 01000000'
  elif [ `echo $P | grep BoldOblique` ]; then
    fsSelection_sed_value='00000000 00100001'
  elif [ `echo $P | grep Bold` ]; then
    fsSelection_sed_value='00000000 00100000'
  elif [ `echo $P | grep Oblique` ]; then
    fsSelection_sed_value='00000000 00000001'
  fi
  sed -i.bak -e 's,fsSelection value="'"$fsSelection_value"'",fsSelection value="'"$fsSelection_sed_value"'",' "${P%%.ttf}.ttx"

  #sed -i.bak -e 's,version value="1",version value="4",' "${P%%.ttf}.ttx"
  
  underlinePosition_value=$(grep 'underlinePosition value' "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  #sed -i.bak -e 's,underlinePosition value="'$underlinePosition_value'",underlinePosition value="-125",' "${P%%.ttf}.ttx"
  sed -i.bak -e 's,underlinePosition value="'$underlinePosition_value'",underlinePosition value="-200",' "${P%%.ttf}.ttx"

  mv "$P" "${P}_orig"
  ttx -m "${P}_orig" "${P%%.ttf}.ttx"
  
  if [ $? -eq 0 ]; then
    mv "$P"  "${BASE_DIR}/build/"
    mv "${P}_orig" "${BASE_DIR}/bak/"
    mv "${P%%.ttf}.ttx" "${BASE_DIR}/bak/"
    rm "${P%%.ttf}.ttx.bak"
  fi
done

for P in ${BASE_DIR}/${HACKGEN53_PATTERN}; do
  ttx -t OS/2 -t post "$P"

  xAvgCharWidth_value=$(grep xAvgCharWidth "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  sed -i.bak -e 's,xAvgCharWidth value="'$xAvgCharWidth_value'",xAvgCharWidth value="'${xAvgCharWidth53_SETVAL}'",' "${P%%.ttf}.ttx"

  fsSelection_value=$(grep fsSelection "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  if [ `echo $P | grep Regular` ]; then
    fsSelection_sed_value='00000000 01000000'
  elif [ `echo $P | grep BoldOblique` ]; then
    fsSelection_sed_value='00000000 00100001'
  elif [ `echo $P | grep Bold` ]; then
    fsSelection_sed_value='00000000 00100000'
  elif [ `echo $P | grep Oblique` ]; then
    fsSelection_sed_value='00000000 00000001'
  fi
  sed -i.bak -e 's,fsSelection value="'"$fsSelection_value"'",fsSelection value="'"$fsSelection_sed_value"'",' "${P%%.ttf}.ttx"

  #sed -i.bak -e 's,version value="1",version value="4",' "${P%%.ttf}.ttx"
  
  underlinePosition_value=$(grep 'underlinePosition value' "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  #sed -i.bak -e 's,underlinePosition value="'$underlinePosition_value'",underlinePosition value="-125",' "${P%%.ttf}.ttx"
  sed -i.bak -e 's,underlinePosition value="'$underlinePosition_value'",underlinePosition value="-200",' "${P%%.ttf}.ttx"

  mv "$P" "${P}_orig"
  ttx -m "${P}_orig" "${P%%.ttf}.ttx"
  
  if [ $? -eq 0 ]; then
    mv "$P"  "${BASE_DIR}/build/"
    mv "${P}_orig" "${BASE_DIR}/bak/"
    mv "${P%%.ttf}.ttx" "${BASE_DIR}/bak/"
    rm "${P%%.ttf}.ttx.bak"
  fi
done
