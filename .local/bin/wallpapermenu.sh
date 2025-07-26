#!/usr/bin/env bash

FOLDER=~/.dotfiles/walls
SCRIPT=~/.dotfiles/scripts/pywal16

menu () {
		CHOICE=$(nsxiv -otb $FOLDER/*) # nsxiv -o writes filename to stdout
}

case $CHOICE in
		*.*) wal -i "$CHOICE" -o $SCRIPT ;;
		*) exit 0 ;;
esac
}

case "$#" in
		0) menu ;;
		1) wal -i "$1" -o $SCRIPT ;;
		2) wal -i "$1" --theme $2 -o $SCRIPT ;;
		*) exit 0 ;;
