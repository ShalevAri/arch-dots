#!/usr/bin/env bash

if [[ -n "$TMUX" ]]; then
  tmux split-window -v -l 30%
  tmux split-window -h -l 66%
  tmux split-window -h -l 50%
else
  echo "Error: Not in a tmux session."
  exit 1
fi
