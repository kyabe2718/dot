#! /usr/bin/env bash

AI_IMAGE_NAME=ai:latest
CONTAINER_NAME="ai"
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)

build() {
  docker build -t ${AI_IMAGE_NAME} ${SCRIPT_DIR}
}

build-no-cache() {
  docker build --no-cache -t ${AI_IMAGE_NAME} ${SCRIPT_DIR}
}

clean() {
  stop
  docker rm ${CONTAINER_NAME}
  docker rmi ${AI_IMAGE_NAME}
  docker builder prune -f
}

stop() {
  docker stop --signal sigint ${CONTAINER_NAME}
}

run() {
  [ -z "$(docker images -q ${AI_IMAGE_NAME})" ] && build

  if !(docker container ls -a -q --filter name=${CONTAINER_NAME} | grep -q .); then
    docker run $MOUNT \
      --user $USER --group-add sudo \
      --name ${CONTAINER_NAME} --detach \
      ${AI_IMAGE_NAME} \
      /bin/bash -c "while true; do sleep 10; done"
  fi

  (docker container ls -q --filter name=${CONTAINER_NAME} | grep -q .) ||\
    docker start ${CONTAINER_NAME}

  docker exec \
    --env OPENAI_API_KEY=${OPENAI_API_KEY} \
    --user $USER -it ${CONTAINER_NAME} $@
}

main() {
    cmd="/.chatgpt-cli/bin/chatgpt-cli"; args=""
    MOUNT="--mount type=bind,source=$PWD,target=/workspace"
    USER="user"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)  usage; exit 0 ;;
            -b|--build) build; exit 0 ;;
            --build-no-cache) build-no-cache; exit 0 ;;
            --stop)     stop;  exit 0 ;;
            --clean)    clean; exit 0 ;;
            --cmd)      shift; cmd="$1";;
            --root)     USER="root";;
            -c|--cli)          cmd="/.chatgpt-cli/bin/chatgpt-cli"; MOUNT="" ;;
            -i|--interpreter)  cmd="/.open-interpreter/bin/interpreter";;
            -y|--yes)          args="$args --yes" ;;
            --no-mount)        MOUNT="" ;;
            --model)    shift; args="$args --model $1";;
            --gpt-3.5)         args="$args --model gpt-3.5-turbo";;
            --gpt-4)           args="$args --model gpt-4";;
            --)         shift; args="$args $@"; break ;;
            *) echo "Unknown option: $1"; usage; exit 1 ;;
        esac
        shift
    done

    run "$cmd$args"
}

usage() {
    cat <<EOF
Usage: $(basename $0) [OPTIONS] [--] [ARGS...]
  -h, --help            Show this help message and exit.
  -c, --cli             Run chatgpt-cli.
  -i, --interpreter     Run interpreter.
  --no-mount            Do not mount current directory.
  --model MODEL         Model to use.
  --gpt-3.5             Use gpt-3.5-turbo model.
  --gpt-4               Use gpt-4 model.
  --root                Run as root.
  --cmd CMD             Command to run in docker container.
  -b, --build           Build docker image.
  --build-no-cache      Build docker image without cache.
  --clean               Clean docker image.
  --stop                Stop docker container.
  --                    Pass the remaining arguments to the command.
EOF
}

main "$@"
