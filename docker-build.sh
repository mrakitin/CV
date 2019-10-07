#!/bin/bash

set -e

mntdir='/build'

command="apt-get update && apt-get install ghostscript -y && cd ${mntdir} && ./build.sh"

docker pull texlive/texlive-full:2017
docker run -it --rm -v $PWD:${mntdir} texlive/texlive-full:2017 bash -c "$command"
