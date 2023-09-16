#!/bin/bash

while IFS= read -r line; do
  if [[ $line == *"OSC123;"* ]]; then
    command=$(echo $line | sed "s/^.*OSC123;//" | sed "s/\x07$//")
    tmux $command
  fi
done
