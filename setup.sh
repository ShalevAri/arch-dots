#!/usr/bin/env bash

set -euo pipefail

trap 'cleanup_temp_files 2>/dev/null || true' EXIT

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

error() { echo -e "${RED}ERROR: $*${NC}" >&2; }
warning() { echo -e "${YELLOW}WARNING: $*${NC}"; }
note() { echo -e "${BLUE}NOTE: $*${NC}"; }
success() { echo -e "${GREEN}SUCCESS: $*${NC}"; }

DOTFILES_REPO="https://github.com/ShalevAri/arch-dots.git"
DOTFILES_DIR="$HOME/.dotfiles"
PARA_DIRS=("1-projects" "2-areas" "3-resources" "4-archives")
PROGS_CSV_URL="https://raw.githubusercontent.com/ShalevAri/arch-dots/main/static/progs.csv"
PROGS_FILE="/tmp/progs.csv"

create_para_directories() {
    note "Creating PARA directories..."
    
    for dir in "${PARA_DIRS[@]}"; do
        local full_path="$HOME/$dir"
        if [[ -d "$full_path" ]]; then
            note "Directory $dir already exists, skipping..."
        else
            mkdir -p "$full_path" || {
                error "Failed to create directory $dir"
                return 1
            }
            success "Created directory $dir"
        fi
    done
    
    success "PARA directories setup completed!"
}

handle_dotfiles_directory() {
    note "Checking .dotfiles directory..."
    
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        note "Creating .dotfiles directory..."
        mkdir -p "$DOTFILES_DIR" || {
            error "Failed to create .dotfiles directory"
            return 1
        }
        success "Created .dotfiles directory"
        return 0
    fi
    
    warning ".dotfiles directory already exists!"
    echo "What would you like to do?"
    echo "1) Abort"
    echo "2) Erase everything inside .dotfiles"
    echo "3) Move to .dotfiles.bak and create new .dotfiles"
    
    while true; do
        read -rp "Please choose an option (1-3): " choice
        case $choice in
            1)
                note "Aborting setup..."
                exit 0
                ;;
            2)
                warning "Erasing contents of .dotfiles directory..."
                rm -rf "${DOTFILES_DIR:?}"/* "${DOTFILES_DIR:?}"/.[!.]* 2>/dev/null || true
                success "Cleared .dotfiles directory"
                return 0
                ;;
            3)
                note "Moving .dotfiles to .dotfiles.bak..."
                if [[ -d "${DOTFILES_DIR}.bak" ]]; then
                    warning "Removing existing .dotfiles.bak..."
                    rm -rf "${DOTFILES_DIR}.bak" || {
                        error "Failed to remove existing .dotfiles.bak"
                        return 1
                    }
                fi
                mv "$DOTFILES_DIR" "${DOTFILES_DIR}.bak" || {
                    error "Failed to move .dotfiles to .dotfiles.bak"
                    return 1
                }
                mkdir -p "$DOTFILES_DIR" || {
                    error "Failed to create new .dotfiles directory"
                    return 1
                }
                success "Moved existing .dotfiles to .dotfiles.bak and created new .dotfiles"
                return 0
                ;;
            *)
                warning "Invalid option. Please choose 1, 2, or 3."
                ;;
        esac
    done
}

download_progs_file() {
    note "Downloading package list from repository..."
    
    if command -v curl >/dev/null 2>&1; then
        if curl -fsSL "$PROGS_CSV_URL" -o "$PROGS_FILE"; then
            success "Downloaded package list successfully"
            return 0
        else
            error "Failed to download package list with curl"
            return 1
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget -q "$PROGS_CSV_URL" -O "$PROGS_FILE"; then
            success "Downloaded package list successfully"
            return 0
        else
            error "Failed to download package list with wget"
            return 1
        fi
    else
        error "Neither curl nor wget found! Please install one of them first."
        return 1
    fi
}

install_packages() {
    note "Installing packages from $PROGS_FILE..."
    
    if [[ ! -f "$PROGS_FILE" ]]; then
        error "Package file $PROGS_FILE not found!"
        return 1
    fi
    
    if ! command -v pacman >/dev/null 2>&1; then
        error "pacman not found! This script is designed for Arch Linux."
        return 1
    fi
    
    local has_aur_packages=false
    while IFS=',' read -r tag name purpose; do
        [[ "$tag" =~ ^#.*$ ]] && continue
        [[ -z "$name" ]] && continue
        tag=$(echo "$tag" | sed 's/^[[:space:]]*"\?//; s/"\?[[:space:]]*$//')
        if [[ "$tag" == "A" || "$tag" == "AUR" || "$tag" == "aur" ]]; then
            has_aur_packages=true
            break
        fi
    done < "$PROGS_FILE"
    
    if [[ "$has_aur_packages" == true ]]; then
        if ! command -v paru >/dev/null 2>&1 && ! command -v yay >/dev/null 2>&1; then
            warning "AUR packages detected but no AUR helper found!"
            note "Install paru with: sudo pacman -S --needed base-devel && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si"
            note "Or install yay with: sudo pacman -S --needed base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
            note "AUR packages will be skipped for now."
        fi
    fi
    
    local pacman_packages=()
    local aur_packages=()
    local count=0
    
    while IFS=',' read -r tag name purpose; do
        [[ "$tag" =~ ^#.*$ ]] && continue
        [[ -z "$name" ]] && continue
        
        tag=$(echo "$tag" | sed 's/^[[:space:]]*"\?//; s/"\?[[:space:]]*$//')
        name=$(echo "$name" | sed 's/^[[:space:]]*"\?//; s/"\?[[:space:]]*$//')
        purpose=$(echo "$purpose" | sed 's/^[[:space:]]*"\?//; s/"\?[[:space:]]*$//')
        
        if [[ -n "$name" ]]; then
            case "$tag" in
                "A"|"AUR"|"aur")
                    aur_packages+=("$name")
                    ;;
                ""|"P"|"pacman")
                    pacman_packages+=("$name")
                    ;;
                *)
                    warning "Unknown tag '$tag' for package '$name', treating as pacman package"
                    pacman_packages+=("$name")
                    ;;
            esac
            ((count++))
        fi
    done < "$PROGS_FILE"
    
    if [[ $count -eq 0 ]]; then
        warning "No packages found in $PROGS_FILE"
        return 0
    fi
    
    note "Found $count packages to install..."
    note "  Pacman packages: ${#pacman_packages[@]}"
    note "  AUR packages: ${#aur_packages[@]}"
    
    local total_found=$((${#pacman_packages[@]} + ${#aur_packages[@]}))
    if [[ $total_found -ne $count ]]; then
        warning "Package count mismatch! Expected $count, got $total_found total packages"
    fi
    
    note "Updating package database..."
    sudo pacman -Syu || {
        error "Failed to update package database"
        return 1
    }
    
    if [[ ${#pacman_packages[@]} -gt 0 ]]; then
        note "Checking which packages need to be installed..."
        
        local packages_to_install=()
        for package in "${pacman_packages[@]}"; do
            if ! pacman -Q "$package" >/dev/null 2>&1; then
                packages_to_install+=("$package")
            else
                note "Package $package is already installed, skipping..."
            fi
        done
        
        if [[ ${#packages_to_install[@]} -gt 0 ]]; then
            note "Installing ${#packages_to_install[@]} official repository packages..."
            note "Packages to install: ${packages_to_install[*]}"
            
            if sudo pacman -S --needed --noconfirm "${packages_to_install[@]}"; then
                success "Successfully installed ${#packages_to_install[@]} packages"
            else
                warning "Some packages failed to install, but continuing..."
            fi
        else
            note "All official repository packages are already installed!"
        fi
    fi
    
    if [[ ${#aur_packages[@]} -gt 0 ]]; then
        local aur_helper=""
        if command -v paru >/dev/null 2>&1; then
            aur_helper="paru"
        elif command -v yay >/dev/null 2>&1; then
            aur_helper="yay"
        else
            error "No AUR helper found! Please install paru or yay first."
            error "Skipping AUR packages: ${aur_packages[*]}"
        fi
        
        if [[ -n "$aur_helper" ]]; then
            note "Checking which AUR packages need to be installed..."
            
            local aur_packages_to_install=()
            for package in "${aur_packages[@]}"; do
                if ! pacman -Q "$package" >/dev/null 2>&1; then
                    aur_packages_to_install+=("$package")
                else
                    note "AUR package $package is already installed, skipping..."
                fi
            done
            
            if [[ ${#aur_packages_to_install[@]} -gt 0 ]]; then
                note "Installing ${#aur_packages_to_install[@]} AUR packages using $aur_helper..."
                note "AUR packages to install: ${aur_packages_to_install[*]}"
                
                if $aur_helper -S --needed --noconfirm "${aur_packages_to_install[@]}"; then
                    success "Successfully installed ${#aur_packages_to_install[@]} AUR packages"
                else
                    warning "Some AUR packages failed to install, but continuing..."
                fi
            else
                note "All AUR packages are already installed!"
            fi
        fi
    fi

    
    success "Package installation completed!"
}

cleanup_temp_files() {
    note "Cleaning up temporary files..."
    if [[ -f "$PROGS_FILE" ]]; then
        rm -f "$PROGS_FILE" || warning "Failed to remove temporary file $PROGS_FILE"
        success "Cleaned up temporary files"
    fi
}

clone_dotfiles() {
    note "Cloning dotfiles repository..."
    
    if ! command -v git >/dev/null 2>&1; then
        error "git not found! Please install git first."
        return 1
    fi
    
    if [[ "$(ls -A "$DOTFILES_DIR" 2>/dev/null)" ]]; then
        warning "Dotfiles directory is not empty, skipping clone..."
        return 0
    fi
    
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || {
        error "Failed to clone dotfiles repository from $DOTFILES_REPO"
        return 1
    }
    
    success "Successfully cloned dotfiles repository!"
}

remove_hyprland_conf() {
    note "Removing ~/.config/hyprland.conf..."
    
    local hypr_conf="$HOME/.config/hyprland.conf"
    
    if [[ -f "$hypr_conf" ]]; then
        rm -f "$hypr_conf" || {
            error "Failed to remove $hypr_conf"
            return 1
        }
        success "Removed $hypr_conf"
    else
        note "$hypr_conf does not exist, skipping..."
    fi
}

stow_dotfiles() {
    note "Setting up dotfiles with stow..."
    
    if ! command -v stow >/dev/null 2>&1; then
        error "stow not found! Please install stow first."
        return 1
    fi
    
    cd "$DOTFILES_DIR" || {
        error "Failed to change to dotfiles directory"
        return 1
    }
    
    if stow .; then
        success "Successfully set up dotfiles with stow!"
    else
        error "stow failed! Aborting setup."
        error "Please check for conflicts and try again."
        return 1
    fi
}

check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root!"
        error "Please run as a regular user."
        exit 1
    fi
}



main() {
    echo "================================================"
    echo "        Arch Linux Dotfiles Setup Script       "
    echo "================================================"
    echo
    
    check_not_root
    
    note "Starting setup process..."
    echo
    
    if create_para_directories; then
        echo
    else
        error "Failed to create PARA directories. Aborting."
        exit 1
    fi
    
    if handle_dotfiles_directory; then
        echo
    else
        error "Failed to handle .dotfiles directory. Aborting."
        exit 1
    fi
    
    if download_progs_file; then
        echo
    else
        error "Failed to download package list. Aborting."
        exit 1
    fi
    
    if install_packages; then
        echo
    else
        error "Failed to install packages. Aborting."
        exit 1
    fi
    
    if clone_dotfiles; then
        echo
    else
        error "Failed to clone dotfiles. Aborting."
        exit 1
    fi
    
    if remove_hyprland_conf; then
        echo
    else
        error "Failed to remove hyprland.conf. Aborting."
        exit 1
    fi
    
    if stow_dotfiles; then
        echo
    else
        error "Stow failed. Aborting."
        exit 1
    fi
    
    cleanup_temp_files
    
    echo "================================================"
    success "Setup completed successfully!"
    echo
    note "Please reboot your system for all changes to take effect."
    echo "================================================"
}

main "$@"
