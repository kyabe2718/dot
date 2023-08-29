#! /usr/bin/env bash

get_ostype() {
    case "${OSTYPE}" in
        solaris*)   echo "SOLARIS" ;;
        linux-gnu*) echo "LINUX"   ;;
        darwin*)    echo "OSX"     ;;
        bsd*)       echo "BSD"     ;;
        msys*)      echo "WINDOWS" ;;
        cygwin*)    echo "WINDOWS" ;;
        *)          echo "UNKNOWN: ${OSTYPE}" ;;
    esac
}

get_linux_distribution() {
    # c.f. https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        echo $NAME
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        echo $(lsb_release -si)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        echo $DISTRIB_ID
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        echo "Debian"
    elif [ -f /etc/SuSe-release ]; then
        # Older SuSE/etc.
        echo "SuSE"
    elif [ -f /etc/redhat-release ]; then
        # Older Red Hat, CentOS, etc.
        echo "RedHat"
    else
        echo $(uname -s)
    fi
}

get_platform() {
    case "$(get_ostype)" in
        LINUX) echo $(get_linux_distribution) ;;
        *)     echo $(get_ostype)             ;;
    esac
}

verlte() {
    [  "$1" = "`echo -e \"$1\n$2\" | sort -V | head -n1`" ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}
