#! /bin/bash


load_from_win_clipboard() {
    # too slow!!!!
    powershell.exe Get-Clipboard | sed 's/\r$//' | sed -z '$ s/\n$//'
}

if type clip.exe > /dev/null 2>&1; then
    echo $(win_load_from_clipboard)
elif type xsel > /dev/null 2>&1; then
    echo $(xsel -bo)
fi
