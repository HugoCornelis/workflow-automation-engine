#!/bin/bash

SCRIPTPATH="$(dirname $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}"))"
DOWNLOAD_DIR="$SCRIPTPATH/image/poky/build/downloads"
BUILD_CACHE_DIR=/tmp/build-yocto

mkdir -p $BUILD_CACHE_DIR

echo "*** Removing the previous neurospaces container"

docker stop neurospaces_interactive
docker container rm neurospaces_interactive
docker container prune -f

USER_NAME=`id -un`
USER_ID=`id -u`
GROUP_ID=`id -g`

WORKING_DIRECTORY=`pwd`

echo "*** Creating the neurospaces container from the its source image"

echo "*** USER_NAME=$USER_NAME"
echo "*** USER_ID=$USER_ID"
echo "*** GROUP_ID=$GROUP_ID"

echo "*** WORKING_DIRECTORY=$WORKING_DIRECTORY"

docker run -d -t --name neurospaces_interactive \
    -v $DOWNLOAD_DIR:/home/$USER_NAME/image/poky/build/downloads \
    -v $BUILD_CACHE_DIR:/home/$USER_NAME/image/poky/build \
    -v $WORKING_DIRECTORY:$WORKING_DIRECTORY \
    neurospaces_image

docker ps

echo "*** Entering the neurospaces container"

docker exec -it --workdir $WORKING_DIRECTORY neurospaces_interactive bash
