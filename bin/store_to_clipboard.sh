#! /bin/bash

if type clip.exe > /dev/null 2>&1; then
    cat - | clip.exe
elif type xsel > /dev/null 2>&1; then
    cat - | xsel -pi && xsel -po | xsel -bi
else
    return 1
fi
