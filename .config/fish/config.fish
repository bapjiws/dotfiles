alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'

alias clean_branches='git branch | grep -v "master" | xargs git branch -D'

fish_vi_key_bindings

starship init fish | source
