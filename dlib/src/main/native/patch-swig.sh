#!/bin/sh

set -euo pipefail

find "${1}" -name "*.java" -print0 | xargs -0 -I {} perl -n -i'.bak' -e '/\b.*JNI\.delete_/ or s/(?!.*delete.*)([^.])\b(swigCPtr[,\)])/$1swigWrap.$2/g; print unless /^ *\(\);$/' "{}"
find "${1}" -name "*.bak" -exec rm "{}" \;
