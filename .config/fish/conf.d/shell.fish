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
