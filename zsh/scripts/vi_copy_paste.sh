#! /usr/bin/env zsh

function store_to_clipboard(){
    cat - | xsel -pi && xsel -po | xsel -bi
}

function load_from_clipboard(){
    echo $(xsel -bo)
}


# bindkey -a .... はvimのcommandモードでのkeybinding

function _xsel_paste(){
    # vimのpに相当させるためにindexを1つずらしている
    LBUFFER=$LBUFFER${RBUFFER:0:1}$(load_from_clipboard)
    RBUFFER=${RBUFFER:1}
}
zle -N _xsel_paste
bindkey -a 'p' _xsel_paste

function _xsel_paste_before(){
    LBUFFER=$LBUFFER$(load_from_clipboard)
}
zle -N _xsel_paste_before
bindkey -a 'P' _xsel_paste_before

function _xsel_copy_line(){
    echo $BUFFER | store_to_clipboard
}
zle -N _xsel_copy_line
bindkey -a 'yy' _xsel_copy_line

