#!/usr/bin/env bash

set -euo pipefail

if ! tmux info &>/dev/null; then
  echo "Error: tmux is not running" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <branch_name> [command...]" >&2
  exit 1
fi

branch_name=$(basename "$1")
session_name=$(tmux display-message -p "#S")
clean_name=$(echo "$branch_name" | tr "./" "__")
target="$session_name:$clean_name"

if ! tmux has-session -t $target 2>/dev/null; then
  tmux neww -dn $clean_name
fi

shift
tmux send-keys -t $target "$*"
