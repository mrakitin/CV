#!/bin/bash

set -e

mntdir='/build'

command="apt-get update && apt-get install -y ghostscript && cd ${mntdir} && ./build.sh"

# The following Docker image does not exist or is not public as of 04/22/2020:
# docker pull texlive/texlive-full:2017

# This Docker image is too large for the CI (~4 GBs!)
# DOCKER_IMAGE=mirisbowring/texlive_ctan_full
# DOCKER_TAG=2017-final
# DOCKER_TAG=2019

# This Docker image has a suitable size for the CI (~300 MBs), but do not have
# the required moderncv.cls file.
# DOCKER_IMAGE=mirisbowring/texlive_ctan_basic
# DOCKER_TAG=2017-final
# DOCKER_TAG=2018-final
# DOCKER_TAG=2019

# This Docker image ...
DOCKER_IMAGE=laurenss/texlive-full
# DOCKER_TAG=2013
# DOCKER_TAG=2015
# DOCKER_TAG=2016
# DOCKER_TAG=2017
# DOCKER_TAG=2018
DOCKER_TAG=2019
# DOCKER_TAG=latest

docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}
docker run -it --rm -v $PWD:${mntdir} ${DOCKER_IMAGE}:${DOCKER_TAG} bash -c "$command"
