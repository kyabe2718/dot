#! /usr/bin/env bash

AI_IMAGE_NAME=ai:latest
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)

if [ -z "$(docker images -q ${AI_IMAGE_NAME})" ]; then
    docker build -t ${AI_IMAGE_NAME} ${SCRIPT_DIR}
fi

docker run \
    --mount type=bind,source=$PWD,target=/workspace \
    --env OPENAI_API_KEY=${OPENAI_API_KEY} \
    -it --rm ${AI_IMAGE_NAME}

