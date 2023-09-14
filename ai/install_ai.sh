#! /usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)

if type ai>/dev/null 2>&1; then
    return
fi

ln -snf ${SCRIPT_DIR}/run.sh $HOME/.local/bin/ai
