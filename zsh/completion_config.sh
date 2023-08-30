#! /usr/bin/env zsh

# See man zshcompsys(1)

# command, context, tags, styles
# tags: what the completion objects are (files, directories, ...)
# styles: how they are to be completed

# context information: ':completion:{function}:{completer}:{command}:{argument}:{tag}'
#   function: The name of widget which calls completion. Typically blank which means the normal completion system.
#   completer: Currently active completer. A completer controls how completion is to be performed
#   command: The name of current command. When completing for commands which have sub-commands, this field is {command}-{subcommand}
#   argument: This indicates which command line or option arguments of completion target. (argumet-{n}, option-{opt}-n)
#   tags: described above

zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # completion uses the same color config as ls command.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case insensitive

