#!/bin/bash

# set -vxeuo pipefail
set -euo pipefail

SCRIPTS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
REPO_ROOT="$(dirname ${SCRIPTS_DIR})"
LINKS_FILE=${1:-'all-links.txt'}
HTML_FILE=${2:-'all-links.html'}

echo "Repo root   : ${REPO_ROOT}"
echo "Scripts dir : ${SCRIPTS_DIR}"
echo "Links file  : ${LINKS_FILE}"
echo "HTML file   : ${HTML_FILE}"

egrep -r -o -E '{http.*://.*}' \
    ${REPO_ROOT}/**.tex \
    ${REPO_ROOT}/src/**.tex \
    ${REPO_ROOT}/**.bib \
    | cut -d'{' -f2 | cut -d'}' -f1 \
    | grep ^http \
    | sed 's/\\//g' \
    | sort -u \
        > ${LINKS_FILE}

echo "Number of lines in ${LINKS_FILE}: $(cat ${LINKS_FILE} | wc -l | sed 's/ //g')"

python ${SCRIPTS_DIR}/format-html.py "${LINKS_FILE}" "${HTML_FILE}"

linkchecker \
    --config=${REPO_ROOT}/.linkcheckerrc \
    --check-extern \
    --file-output html/all-links-report.html \
    ${HTML_FILE}
