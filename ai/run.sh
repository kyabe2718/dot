#! /usr/bin/env bash

AI_IMAGE_NAME=ai:latest
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)

usage() {
    echo "Usage: $0 [options]"
}

build() {
    docker build -t ${AI_IMAGE_NAME} ${SCRIPT_DIR}
    # docker builder prune -f # clean up
}

run() {
    docker run \
        --mount type=bind,source=$PWD,target=/workspace \
        --env OPENAI_API_KEY=${OPENAI_API_KEY} \
        --user $(id -u):$(id -g) \
        --group-add sudo \
        -it --rm ${AI_IMAGE_NAME} "$@"
}

main() {
    if [ -z "$(docker images -q ${AI_IMAGE_NAME})" ]; then
        build
    fi

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage; exit 0 ;;
            -b|--build)
                build; exit 0 ;;
            --clean)
                docker rmi ${AI_IMAGE_NAME}; exit 0 ;;
            -c|--command)
                shift; run "$@"; exit 0 ;;
            --) shift; break ;;
            *)
                echo "Unknown option: $1"; usage; exit 1 ;;
        esac
    done
    run "interpreter" "-y" "$@"
}

main "$@"
