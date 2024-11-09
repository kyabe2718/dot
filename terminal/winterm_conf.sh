#! /usr/bin/env bash

get_settings_json_path() {
    WINDOWS_HOME=$(cmd.exe /C "echo %userprofile%" 2> /dev/null | tr -d '\r' | sed -e 's/C:/\/mnt\/c/' -e 's/\\/\//g')
    WINTERM_DIR=$(ls $WINDOWS_HOME/AppData/Local/Packages/ | grep "Microsoft.WindowsTerminal")
    PATH_TO_SETTINGS_JSON="$WINDOWS_HOME/AppData/Local/Packages/$WINTERM_DIR/LocalState/settings.json"
    echo $PATH_TO_SETTINGS_JSON
}

backup() {
    cp $(get_settings_json_path) $(get_settings_json_path).bak
}

restore() {
    cp $(get_settings_json_path).bak $(get_settings_json_path)
}

opt_to_key() {
    case $1 in
        cursor_shape) echo "cursorShape";;
        font) echo "font.face";;
        font_size) echo "font.size";;
        guid) echo "guid";;
        name) echo "name";;
        source) echo "source";;
        opacity) echo "opacity";;
        *) echo "Unknown option: $1" >&2; exit 1;;
    esac
}

quote_if_string() {
    local value=$1
    [[ $value =~ ^[0-9]+$ ]] && echo $value || echo "\"$value\""
}

get_config() {
    local key =$(opt_to_key $1)
    [[ -z $key ]] && exit 1
    cat $(get_settings_json_path) | jq ".profiles.defaults | select(.$key != null) | .$key"
}

set_config() {
    local key=$(opt_to_key $1)
    local value=$(quote_if_string $2)
    [[ -z $key ]] && exit 1
    [[ -z $value ]] && echo "No value provided for $key" >&2 && exit 1
    local path_to_settings_json=$(get_settings_json_path)
    echo ".profiles.defaults.$key=$value"
    cat $path_to_settings_json |\
        jq ".profiles.defaults.$key = $value" > $path_to_settings_json
}

main() {
    arg=$1; shift
    case $arg in
        help) usage "$@"; exit 0;;
        get) get_config "$@"; exit 0;;
        set) set_config "$@"; exit 0;;
        backup) backup; exit 0;;
        restore) restore; exit 0;;
        path) get_settings_json_path; exit 0;;
        *) echo "Unknown option: $1" >&2; exit 1;;
    esac
}

main "$@"
