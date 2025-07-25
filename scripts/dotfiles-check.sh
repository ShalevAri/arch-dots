#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

error() { echo -e "${RED}✗ $*${NC}"; }
warning() { echo -e "${YELLOW}⚠ $*${NC}"; }
info() { echo -e "${BLUE}ℹ $*${NC}"; }
success() { echo -e "${GREEN}✓ $*${NC}"; }

TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

check_result() {
  local status="$1"
  TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
  case "$status" in
    "pass") PASSED_CHECKS=$((PASSED_CHECKS + 1)) ;;
    "fail") FAILED_CHECKS=$((FAILED_CHECKS + 1)) ;;
    "warn") WARNING_CHECKS=$((WARNING_CHECKS + 1)) ;;
  esac
}

check_directory() {
  local dir="$1"
  local desc="$2"
  
  if [[ -d "$dir" ]]; then
    success "$desc: $dir"
    check_result "pass"
  else
    error "$desc: $dir (missing)"
    check_result "fail"
  fi
}

check_file() {
  local file="$1"
  local desc="$2"
  
  if [[ -f "$file" ]]; then
    success "$desc: $file"
    check_result "pass"
  else
    error "$desc: $file (missing)"
    check_result "fail"
  fi
}

check_executable() {
  local file="$1"
  local desc="$2"
  
  if [[ -f "$file" && -x "$file" ]]; then
    success "$desc: $file"
    check_result "pass"
  elif [[ -f "$file" ]]; then
    warning "$desc: $file (exists but not executable)"
    check_result "warn"
  else
    error "$desc: $file (missing)"
    check_result "fail"
  fi
}

check_symlink() {
  local link="$1"
  local desc="$2"
  
  if [[ -L "$link" && -e "$link" ]]; then
    success "$desc: $link → $(readlink "$link")"
    check_result "pass"
  elif [[ -L "$link" ]]; then
    error "$desc: $link (broken symlink)"
    check_result "fail"
  elif [[ -e "$link" ]]; then
    warning "$desc: $link (exists but not a symlink)"
    check_result "warn"
  else
    error "$desc: $link (missing)"
    check_result "fail"
  fi
}

DOTFILES_DIR="$HOME/.dotfiles"

echo "🔍 Dotfiles Integrity Check"
echo "=========================="
echo

info "Checking dotfiles directory..."
check_directory "$DOTFILES_DIR" "Dotfiles directory"
echo

info "Checking configuration directories..."
check_directory "$DOTFILES_DIR/.config" "Main config directory"
check_directory "$DOTFILES_DIR/.config/hypr" "Hyprland config"
check_directory "$DOTFILES_DIR/.config/fish" "Fish shell config"
check_directory "$DOTFILES_DIR/.config/nvim" "Neovim config"
check_directory "$DOTFILES_DIR/.config/nvim-files" "Neovim files backup"
check_directory "$DOTFILES_DIR/.config/doom" "DOOM Emacs config"
check_directory "$DOTFILES_DIR/.config/doom-files" "DOOM Emacs files backup"
check_directory "$DOTFILES_DIR/.config/ghostty" "Ghostty terminal config"
check_directory "$DOTFILES_DIR/.config/waybar" "Waybar config"
check_directory "$DOTFILES_DIR/.config/starship" "Starship prompt config"
echo

info "Checking script directories..."
check_directory "$DOTFILES_DIR/scripts" "Utility scripts directory"
check_directory "$DOTFILES_DIR/personal" "Personal directory"
check_directory "$DOTFILES_DIR/personal/dev" "Development scripts directory"
echo

info "Checking essential configuration files..."
check_file "$DOTFILES_DIR/.config/hypr/hyprland.conf" "Hyprland main config"
check_file "$DOTFILES_DIR/.config/fish/config.fish" "Fish main config"
check_file "$DOTFILES_DIR/.config/nvim/init.lua" "Neovim init file"
check_file "$DOTFILES_DIR/.stow-local-ignore" "Stow ignore file"
echo

info "Checking utility scripts..."
check_executable "$DOTFILES_DIR/setup.sh" "Main setup script"
check_executable "$DOTFILES_DIR/scripts/tmux-sessionizer.sh" "Tmux sessionizer"
check_executable "$DOTFILES_DIR/scripts/tmux-windowizer.sh" "Tmux windowizer"
check_executable "$DOTFILES_DIR/scripts/ide.sh" "IDE script"
check_executable "$DOTFILES_DIR/scripts/songdetail.sh" "Song detail script"
echo

info "Checking development scripts..."
check_executable "$DOTFILES_DIR/personal/dev/packages.sh" "Package manager script"
check_executable "$DOTFILES_DIR/personal/dev/nvimsync.sh" "Neovim sync script"
check_executable "$DOTFILES_DIR/personal/dev/doomsync.sh" "DOOM Emacs sync script"
check_executable "$DOTFILES_DIR/personal/dev/git.sh" "Git helper script"
check_executable "$DOTFILES_DIR/personal/dev/sysmain.sh" "System maintenance script"
echo

info "Checking symlinked configurations..."
check_symlink "$HOME/.config/hypr" "Hyprland config symlink"
check_symlink "$HOME/.config/fish" "Fish config symlink"
check_symlink "$HOME/.config/nvim" "Neovim config symlink"
echo

info "Checking PARA directories..."
check_directory "$HOME/1-projects" "Projects directory"
check_directory "$HOME/2-areas" "Areas directory"
check_directory "$HOME/3-resources" "Resources directory"
check_directory "$HOME/4-archives" "Archives directory"
echo

# Check documentation
info "Checking documentation..."
check_file "$DOTFILES_DIR/README.md" "Main README"
check_file "$DOTFILES_DIR/docs/INSTALLATION.md" "Installation guide"
check_file "$DOTFILES_DIR/docs/USAGE.md" "Usage guide"
check_file "$DOTFILES_DIR/docs/DESIGN.md" "Design document"
check_file "$DOTFILES_DIR/docs/NEXT_STEPS.md" "Next steps guide"
echo

# Summary
echo "📊 Summary"
echo "=========="
echo "Total checks: $TOTAL_CHECKS"
success "Passed: $PASSED_CHECKS"
if [[ $WARNING_CHECKS -gt 0 ]]; then
  warning "Warnings: $WARNING_CHECKS"
fi
if [[ $FAILED_CHECKS -gt 0 ]]; then
  error "Failed: $FAILED_CHECKS"
else
  echo
  success "All critical checks passed! Your dotfiles appear to be intact."
fi

# Exit with appropriate code
if [[ $FAILED_CHECKS -gt 0 ]]; then
  exit 1
elif [[ $WARNING_CHECKS -gt 0 ]]; then
  exit 2
else
  exit 0
fi 