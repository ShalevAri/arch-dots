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

note "Setting up Git and Jujutsu configuration..."

read -r -p "Enter your Git username: " git_username
read -r -p "Enter your Git email: " git_email

if [ -z "$git_username" ] || [ -z "$git_email" ]; then
  error "Git username and email are required. Aborting."
  exit 1
fi

git config --global user.name "$git_username" || {
  error "Failed to set Git username. Aborting."
  exit 1
}

git config --global user.email "$git_email" || {
  error "Failed to set Git email. Aborting."
  exit 1
}

jj config set --user user.name "$git_username" || {
  error "Failed to set Jujutsu username. Aborting."
  exit 1
}

jj config set --user user.email "$git_email" || {
  error "Failed to set Jujutsu email. Aborting."
  exit 1
}

success "Git and Jujutsu configuration completed successfully!"
note "Username: $git_username"
note "Email: $git_email"
