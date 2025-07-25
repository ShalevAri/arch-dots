# Next Steps

This document contains the next steps you need to manually take in order to finish the installation.

## Neovim Setup

Neovim is currently not set up properly, this is normal.

To set it up, you need to do the following:

1. Delete the `~/.dotfiles/.config/nvim` and `~/.config/nvim` directories
2. Clone the LazyVim repository to `~/.config/nvim`
3. Remove the `.git` directory in `~/.config/nvim`
4. Run `nvim` in your terminal to install LazyVim
5. Delete the newly created `~/.config/nvim` directory (and `~/.dotfiles/.config/nvim` if it was created again)
6. Copy everything from `~/.dotfiles/.config/nvim-files` to `~/.dotfiles/.config/nvim`
7. `cd` into `~/.dotfiles`
8. Run `stow .` to symlink the files
9. Run `nvim` again to install the new plugins
10. You're done!

Do NOT modify the `nvim-files` directory manually.

It should only be modified using the `nvimsync` script located at `$HOME/personal/dev/nvimsync.sh`
