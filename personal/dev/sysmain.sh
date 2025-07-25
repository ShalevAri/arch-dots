#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

error() { echo -e "${RED}ERR: $*${NC}"; }
warning() { echo -e "${YELLOW}WARNING: $*${NC}"; }
note() { echo -e "${BLUE}NOTE: $*${NC}"; }
success() { echo -e "${GREEN}$*${NC}"; }

check_dependencies() {
  local missing_deps=()
  
  if ! command -v paru >/dev/null 2>&1; then
    missing_deps+=("paru")
  fi
  
  if ! command -v paccache >/dev/null 2>&1; then
    missing_deps+=("pacman-contrib")
  fi
  
  if [ ${#missing_deps[@]} -gt 0 ]; then
    error "Missing dependencies: ${missing_deps[*]}"
    note "Please install the missing packages and run this script again."
    exit 1
  fi
}

display_space_usage() {
  local path="$1"
  local description="$2"
  
  if [ -d "$path" ]; then
    local space_used
    space_used=$(du -sh "$path" 2>/dev/null | cut -f1)
    echo "$description: $space_used"
  else
    warning "$description: Directory not found ($path)"
  fi
}

note "Starting system maintenance..."
echo

check_dependencies

echo "----------------------------------------------------"
echo "UPDATING SYSTEM"
echo "----------------------------------------------------"

note "Updating system packages..."
if paru -Syu --noconfirm; then
  success "System update completed successfully!"
else
  error "System update failed!"
  exit 1
fi

echo ""
echo "----------------------------------------------------"
echo "CLEARING PACMAN CACHE"
echo "----------------------------------------------------"

display_space_usage "/var/cache/pacman/pkg/" "Space currently in use"
echo ""

note "Clearing cache, leaving newest 2 versions..."
if paccache -vrk2; then
  success "Cache cleanup (keeping 2 versions) completed!"
else
  warning "Cache cleanup (keeping 2 versions) encountered issues"
fi

echo ""
note "Clearing all uninstalled packages from cache..."
if paccache -ruk0; then
  success "Uninstalled packages cache cleanup completed!"
else
  warning "Uninstalled packages cache cleanup encountered issues"
fi

echo ""
display_space_usage "/var/cache/pacman/pkg/" "Space after cleanup"

echo ""
echo "----------------------------------------------------"
echo "REMOVING ORPHANED PACKAGES"
echo "----------------------------------------------------"

note "Checking for orphaned packages..."
orphaned=$(paru -Qdtq 2>/dev/null || true)
if [ -n "$orphaned" ]; then
  note "Found orphaned packages:"
  echo "$orphaned" | sed 's/^/  /'
  echo ""
  note "Removing orphaned packages..."
  if echo "$orphaned" | paru -Rns --noconfirm -; then
    success "Orphaned packages removed successfully!"
  else
    warning "Some orphaned packages could not be removed"
  fi
else
  success "No orphaned packages found!"
fi

echo ""
echo "----------------------------------------------------"
echo "CLEARING HOME CACHE"
echo "----------------------------------------------------"

if [ -d "$HOME/.cache" ]; then
  display_space_usage "$HOME/.cache" "Home cache space used"
  echo ""
  note "Clearing ~/.cache/..."
  if rm -rf "$HOME/.cache"/*; then
    success "Home cache cleared successfully!"
  else
    warning "Some files in home cache could not be removed"
  fi
  
  mkdir -p "$HOME/.cache"
else
  note "No ~/.cache directory found"
fi

echo ""
echo "----------------------------------------------------"
echo "CLEARING SYSTEM LOGS"
echo "----------------------------------------------------"

note "Clearing system logs (keeping last 7 days)..."
if sudo journalctl --vacuum-time=7d; then
  success "System logs cleanup completed!"
else
  warning "System logs cleanup encountered issues"
fi

echo ""
echo "----------------------------------------------------"
echo "MAINTENANCE SUMMARY"
echo "----------------------------------------------------"

success "System maintenance completed!"
note "Summary of actions performed:"
echo "  ✓ System packages updated"
echo "  ✓ Pacman cache cleaned (kept 2 newest versions)"
echo "  ✓ Orphaned packages removed"
echo "  ✓ Home cache cleared"
echo "  ✓ System logs cleaned (kept last 7 days)"
echo ""
note "Consider rebooting if kernel or core system components were updated."