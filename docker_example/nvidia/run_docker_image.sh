#!/bin/bash


docker_image="${1:my-cuda-gui-app}"
MYHOME=/home/tdwebste

sudo docker run -it --rm --gpus all \
    --runtime=nvidia \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v "$MYHOME/.Xauthority:/home/devuser/.Xauthority:rw" \
    -v "$MYHOME/src/openfoam:/home/devuser/src/openfoam:rw" \
    --user devuser \
    $docker_image \
    bash
