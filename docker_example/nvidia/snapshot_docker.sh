#!/bin/bash

image="my-cuda-gui-app"
name=$(docker ps -a --format "{{.Names}}" --filter "ancestor=$image" | head -n1)

if [[ -z "$name" ]]; then
    echo "No running or stopped container found for image $image."
    exit 1
fi

snapshot_name="${image}_snapshot:$(date +'%Y%m%d_%H%M%S')"
echo "docker commit $name $snapshot_name"
docker commit "$name" "$snapshot_name"

latest_name="${image}_snapshot:latest"
echo "docker commit $name $latest_name"
docker commit "$name" "$latest_name"

docker images | grep "$image"

