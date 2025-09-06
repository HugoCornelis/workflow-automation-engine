#!/bin/bash

SCRIPTPATH="$(dirname $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}"))"

USER_NAME=`id -un`
USER_ID=`id -u`
GROUP_ID=`id -g`

WORKING_DIRECTORY=`pwd`

echo "Creating a Docker image for $USER_NAME ($USER_ID, $GROUP_ID) for working_directory $WORKING_DIRECTORY from directory $SCRIPTPATH"

echo "Docker file is "`ls ./vigilia/specifications/20_vigilia/Dockerfile.neurospaces-testing*`

docker image prune -f

docker build \
     --tag vigilia_test_image \
     --file ./vigilia/specifications/dockerfiles/Dockerfile.neurospaces-testing \
     .

     # --build-arg USER_NAME=$USER_NAME \
     # --build-arg USER_ID=$USER_ID \
     # --build-arg GROUP_ID=$GROUP_ID \
     # --build-arg WORKING_DIRECTORY=$WORKING_DIRECTORY \

