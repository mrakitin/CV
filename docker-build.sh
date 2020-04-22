#!/bin/bash

set -e

mntdir='/build'

command="apt-get update && apt-get install ghostscript -y && cd ${mntdir} && ./build.sh"

# The following Docker image does not exist or is not public as of 04/22/2020:
# docker pull texlive/texlive-full:2017

DOCKER_IMAGE=mirisbowring/texlive_ctan_full

docker pull ${DOCKER_IMAGE}
docker run -it --rm -v $PWD:${mntdir} ${DOCKER_IMAGE} bash -c "$command"
