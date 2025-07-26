### SHELL.FISH ###

# Other parts of my Dotfiles rely on these commands to "not have" sudo, so removing this may have unintended consequences
for command in mount umount sv pacman updatedb su shutdown poweroff reboot
    alias $command="sudo $command"
end

# Verbosity and settings that you pretty much always want
alias cp "cp -iv"
alias mv "mv -iv"
alias rm "rm -v"
alias bc "bc -ql"
alias rsync "rsync -vrPlu"
alias mkd "mkdir -pv"
alias yt "yt-dlp --embed-metadata -i"
alias yta "yt -x -f bestaudio/best"
alias ytt "yt --skip-download --write-thumbnail"
alias ffmpeg "ffmpeg -hide_banner"
alias untar "tar -zxvf"
alias sha "shasum -a 256"
alias cloudencrypt "gpg -c --no-symkey-cache --cipher-algo AES256"

# Colorize commands when possible
alias grep "grep --color=auto"
alias diff "diff --color=auto"
alias ccat "highlight --out-format=ansi"
alias ip "ip -color=auto"

# These commands are too long so make them shorter
alias cl clear
alias ka killall
alias g git
alias lg lazygit
alias pn pnpm
alias sdn "shutdown -h now"
alias e "$EDITOR"
alias v "$EDITOR"
alias clearcp "wl-copy --clear"
alias clcp "wl-copy --clear"

# bm-dirs
alias dot "cd $HOME/.dotfiles"
alias cac "cd $HOME/.cache"
alias cf "cd $HOME/.dotfiles/.config"
alias D "cd $HOME/Downloads"
alias d "cd $HOME/Documents"
alias dt "cd $HOME/.local/share"
alias rr "cd $HOME/.local/src"
alias h "cd $HOME"
alias m "cd $HOME/Music"
alias pp "cd $HOME/Pictures"
alias sc "cd $HOME/.local/bin"
alias src "cd $HOME/.local/src"
alias vv "cd $HOME/Videos"

# bm-files
alias bf "nvim $HOME/.dotfiles/.config/shell/bm-files"
alias bd "nvim $HOME/.dotfiles/.config/shell/bm-dirs"
alias cfv "nvim $HOME/.dotfiles/.config/nvim/init.lua"
alias cff "nvim $HOME/.dotfiles/.config/fish/config.fish"
alias cfa "nvim $HOME/.dotfiles/.config/shell/aliasrc"
alias cfp "nvim $HOME/.dotfiles/.config/shell/profile"
alias cfn "nvim $HOME/.dotfiles/.config/newsboat/config"
alias cfu "nvim $HOME/.dotfiles/.config/newsboat/urls"
alias cfmb "nvim $HOME/.dotfiles/.config/ncmpcpp/bindings"
alias cfmc "nvim $HOME/.dotfiles/.config/ncmpcpp/config"
alias cfl "nvim $HOME/.dotfiles/.config/lf/lfrc"
alias cfL "nvim $HOME/.dotfiles/.config/lf/scope"
alias cfX "nvim $HOME/.dotfiles/.config/nsxiv/exec/key-handler"
