#! /usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)

install_tools() {
    case "${OSTYPE}" in
        linux*)
            [ -e /etc/os-release ] && os_release='/etc/os-release' || os_release='/usr/lib/os-release'
            . $os_release
            case "$ID" in
                ubuntu)
                    sudo apt install -y \
                        fuse \
                        fzf \
                        xsel \
                        gcc g++ automake build-essential
                    ;;
                *) echo "failed to install others";;
            esac
            ;;
        *) echo "failed to install others";;
    esac
}

usage() {
    cat <<EOF
Usage: $(basename $0) [target...]
Target:
    docker  Install docker
    all     Install all
EOF
}

main() {
    targets=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            help) usage; exit 0 ;;
            docker) targets+=("docker");;
            all) targets+=("docker");;
            *) echo "Unknown option: $1"; usage; exit 1 ;;
        esac
        shift
    done

    for tgt in ${targets[@]}; do
        echo -e "Install $tgt..."
        ${SCRIPT_DIR}/scripts/install_${tgt}.sh
    done

}

main "$@"
