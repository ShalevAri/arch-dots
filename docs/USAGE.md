# Usage

My Dotfiles require you to work a certain way. It is therefore recommended that you read the entirety of this document before proceeding.

## Installing Packages

After installing a package (whether using `pacman` or through the AUR) make sure to add the package to the `~/.dotfiles/static/progs.csv` csv file.

## Neovim

When making changes to your neovim configuration, only modify the `~/.dotfiles/.config/nvim` directory.

DO NOT modify any of the following directories:

- `~/.config/nvim`
- `~/.dotfiles/.config/nvim-files`
- `~/.config/nvim-files`

After making changes you want to keep, run the `nvimsync` script found in `$HOME/personal/dev/nvimsync.sh`.

This will sync the changes from `~/.dotfiles/.config/nvim` to the `~/.dotfiles/.config/nvim-files` directory.

This is used to bootstrap your neovim config on new installations and/or other machines
