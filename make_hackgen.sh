#!/bin/bash

hackgen_version="2.9.0"

BASE_DIR=$(cd $(dirname $0); pwd)
PREFIX="$1"

function mvBuild() {
  mkdir -p "${BASE_DIR}/build/"
  mv -f "${BASE_DIR}/"HackGen*.ttf "${BASE_DIR}/build/"
}

"${BASE_DIR}/hackgen_generator.sh" "$PREFIX" "$hackgen_version" \
&& "${BASE_DIR}/copyright.sh" "$PREFIX" \
&& "${BASE_DIR}/os2_patch.sh" "$PREFIX" \
&& "${BASE_DIR}/cmap_patch.sh" "$PREFIX" \
&& mvBuild
