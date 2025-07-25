#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  shift
fi

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

error()   { echo -e "${RED}ERR: $*${NC}"; }
warning() { echo -e "${YELLOW}WARNING: $*${NC}"; }
note()    { echo -e "${BLUE}NOTE: $*${NC}"; }
success() { echo -e "${GREEN}$*${NC}"; }

DOTFILES_DIR="$HOME/.dotfiles"
NVIM_DIR="$DOTFILES_DIR/.config/nvim"
NVIM_FILES_DIR="$DOTFILES_DIR/.config/nvim-files"

if [ ! -d "$DOTFILES_DIR" ]; then
  error "The dotfiles directory ($DOTFILES_DIR) does not exist. Aborting."
  exit 1
fi

if [ ! -d "$NVIM_DIR" ]; then
  error "The nvim directory ($NVIM_DIR) does not exist. Aborting."
  exit 1
fi

if [ ! -d "$NVIM_FILES_DIR" ]; then
  error "The nvim-files directory ($NVIM_FILES_DIR) does not exist. Aborting."
  exit 1
fi

if [ ! "$(ls -A "$NVIM_DIR" 2>/dev/null)" ]; then
  warning "The nvim directory ($NVIM_DIR) is empty. Nothing to sync."
  exit 0
fi

if [[ "$DRY_RUN" == true ]]; then
  note "DRY RUN MODE - No changes will be made"
  note "Would create backup: $NVIM_FILES_DIR.bak"
  note "Would remove contents of: $NVIM_FILES_DIR"
  note "Would copy from: $NVIM_DIR"
  note "Would copy to: $NVIM_FILES_DIR"
  success "Dry run completed successfully!"
  exit 0
fi

note "Creating backup of nvim-files directory..."
if [ -d "$NVIM_FILES_DIR.bak" ]; then
  rm -rf "$NVIM_FILES_DIR.bak" || { error "Failed to remove existing backup. Aborting."; exit 1; }
fi
cp -r "$NVIM_FILES_DIR" "$NVIM_FILES_DIR.bak" || { error "Failed to create backup. Aborting."; exit 1; }
success "Backup created successfully!"

note "Removing contents of nvim-files directory..."
rm -rf "$NVIM_FILES_DIR"/* || { error "Failed to remove contents of nvim-files directory. Aborting."; exit 1; }

note "Copying contents from nvim to nvim-files..."
cp -r "$NVIM_DIR"/* "$NVIM_FILES_DIR"/ || { error "Failed to copy contents. Aborting."; exit 1; }

success "Successfully synchronized nvim files!"
note "A backup of the previous nvim-files directory was created at $NVIM_FILES_DIR.bak"
note "Usage: $0 [--dry-run] to preview changes without making them"
