#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)

"${BASE_DIR}/hackgen_generator.sh" auto
"${BASE_DIR}/os2_patch.sh"
