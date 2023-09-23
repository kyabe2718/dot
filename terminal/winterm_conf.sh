#! /usr/bin/env bash

main() {
    WINDOWS_HOME=$(cmd.exe /C "echo %userprofile%" 2> /dev/null | tr -d '\r' | sed -e 's/C:/\/mnt\/c/' -e 's/\\/\//g')
    WINTERM_DIR=$(ls $WINDOWS_HOME/AppData/Local/Packages/ | grep "Microsoft.WindowsTerminal")
    PATH_TO_SETTINGS_JSON="$WINDOWS_HOME/AppData/Local/Packages/$WINTERM_DIR/LocalState/settings.json"
    cat $PATH_TO_SETTINGS_JSON | jq '.profiles.defaults = {}' > tmp.json && mv tmp.json $PATH_TO_SETTINGS_JSON
}

main
