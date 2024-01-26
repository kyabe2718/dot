#/usr/bin/env bash

main() {
    if type zsh >/dev/null 2>&1; then
        echo "zsh is already installed"
        return
    fi

    if [[ ${OSTYPE} = linux-gnu* ]]; then
        [ -e /etc/os-release ] && os_release='/etc/os-release' || os_release='/usr/lib/os-release'
        . ${os_release}
        if [[ $ID == "ubuntu" ]]; then
            sudo apt install -y zsh
        else
            echo "Unknown Platform: $ID"
            return
        fi
    else
        echo "Unknown Platform: ${OSTYPE}"
        return
    fi

    chsh -s $(which zsh)
}

main
