#!/usr/bin/env bash

set -euo pipefail

for cmd in fzf tmux; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd is not installed or not in PATH" >&2
    exit 1
  fi
done

if [[ $# -eq 1 ]]; then
  selected=$1
  if [[ ! -d "$selected" ]]; then
    echo "Error: Directory '$selected' does not exist" >&2
    exit 1
  fi
else
  search_dirs=()
  for dir in ~/.dotfiles ~/1-projects ~/2-areas ~/3-resources ~/4-archives ~/personal; do
    [[ -d "$dir" ]] && search_dirs+=("$dir")
  done
  
  if [[ ${#search_dirs[@]} -eq 0 ]]; then
    echo "Error: No valid directories found to search" >&2
    exit 1
  fi
  
  selected=$(find "${search_dirs[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s $selected_name -c $selected
  exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
  tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
