set fish_greeting
set TERM xterm-256color

# Set default editor and manpager 
# NOTE: Choose either Emacs OR Neovim, not both

# set -x EDITOR "emacsclient -t -a ''"
# set -x VISUAL "emacsclient -c -a emacs"
set -x EDITOR helix
set -x VISUAL helix

set -x MANPAGER "nvim +Man!"

function fish_user_key_bindings
    fish_vi_key_bindings
end

set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

### ZELLIJ ###
set -x ZELLIJ_CONFIG_FILE $HOME/.config/zellij/config.kdl

### RUST ###
set -x PATH $HOME/.cargo/bin $PATH

### BAT ###
set -x BAT_THEME Catppuccin-mocha

### ZOXIDE ###
zoxide init fish | source

### BUN ###
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

### GO ###
set -gx GOPATH $HOME/go
set -U fish_user_paths $GOPATH/bin $HOME/.local/bin $fish_user_paths

### DOOM ###
set -gx PATH $PATH $HOME/.config/emacs/bin

### FZF ###
fzf --fish | source

### STARSHIP ###
starship init fish | source
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
