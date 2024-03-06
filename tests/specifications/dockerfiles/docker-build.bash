#!/bin/bash

SCRIPTPATH="$(dirname $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}"))"

USER_NAME=`id -un`
USER_ID=`id -u`
GROUP_ID=`id -g`

WORKING_DIRECTORY=`pwd`

DOCKERFILE="./tests/specifications/dockerfiles/Dockerfile.workflow"

echo "Creating a Docker image for $USER_NAME ($USER_ID, $GROUP_ID) for working_directory $WORKING_DIRECTORY from directory $SCRIPTPATH"

#t should do error checking here, but actually in the tester harness

sudo docker image prune -f
sudo docker build \
    --tag workflow_automation_image \
    --file $DOCKERFILE \
    .

    # --build-arg USER_NAME=$USER_NAME \
    # --build-arg USER_ID=$USER_ID \
    # --build-arg GROUP_ID=$GROUP_ID \
    # --build-arg WORKING_DIRECTORY=$WORKING_DIRECTORY \
