#!/bin/bash

# set -vxeuo pipefail
set -euo pipefail

SCRIPTS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
REPO_ROOT="$(dirname ${SCRIPTS_DIR})"
LINKS_FILE=${1:-'/tmp/all-links.txt'}

echo "Repo root   : ${REPO_ROOT}"
echo "Scripts dir : ${SCRIPTS_DIR}"
echo "Links file  : ${LINKS_FILE}"

git grep -r http ${REPO_ROOT}/src/*.tex | cut -d'{' -f2 | cut -d'}' -f1 | grep ^http | sort -u > ${LINKS_FILE}

python ${SCRIPTS_DIR}/format-html.py "${LINKS_FILE}"
