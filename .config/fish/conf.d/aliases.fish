### ALIASES.FISH ###

### CD ###
alias .. "cd .."
alias ... "cd ../.."
alias .3 "cd ../../.."
alias .4 "cd ../../../.."
alias .5 "cd ../../../../.."

### SHRED ###
alias pdel "shred -vzu -n 100"

### TMUX ###
alias tls "tmux list-sessions"
alias tkas "tmux kill-session -a"

### EZA ###
alias l ll
alias ls "eza -a --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll "eza -l -a --color=always --group-directories-first"
alias la "eza -a --color=always --group-directories-first"
alias lld "eza -1 --icons=always -d -T -a --level=1"
alias lld1 "eza -1 --icons=always -d -T -a --level=1"
alias lld2 "eza -1 --icons=always -d -T -a --level=2"
alias lld3 "eza -1 --icons=always -d -T -a --level=3"
alias lld4 "eza -1 --icons=always -d -T -a --level=4"
alias lld5 "eza -1 --icons=always -d -T -a --level=5"
alias lt "eza -aT --color=always --group-directories-first"

### ZOXIDE ###
alias zoxide-show-query "zoxide query -l -s | less"
