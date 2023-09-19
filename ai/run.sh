#! /usr/bin/env bash

AI_IMAGE_NAME=ai:latest
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)

build() {
    docker build -t ${AI_IMAGE_NAME} ${SCRIPT_DIR}
}

clean() {
    docker rmi ${AI_IMAGE_NAME}
}

run() {
    docker run \
        $MOUNT \
        --env OPENAI_API_KEY=${OPENAI_API_KEY} \
        --user $USER \
        --group-add sudo \
        -it --rm ${AI_IMAGE_NAME} $@
}

main() {
    if [ -z "$(docker images -q ${AI_IMAGE_NAME})" ]; then
        build
    fi

    cmd="chatgpt-cli"; args=""
    MOUNT="--mount type=bind,source=$PWD,target=/workspace"
    USER="user"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)  usage; exit 0 ;;
            -b|--build) build; exit 0 ;;
            --clean)    clean; exit 0 ;;
            --cmd)      shift; cmd="$1";;
            --root)     USER="root";;
            -c|--cli)          cmd="chatgpt-cli"; MOUNT="" ;;
            -i|--interpreter)  cmd="interpreter";;
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
    # echo "$cmd$args"
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
  --clean               Clean docker image.
EOF
}

main "$@"
