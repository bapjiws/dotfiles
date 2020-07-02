alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'

# TODO: change the alias.
alias delete_non-master_branches='git checkout master && git branch | grep -v "master" | xargs git branch -D'

fish_vi_key_bindings

starship init fish | source

# TODO: find a way to use it inside .vimrc.
export VIM_SESSION_DIR=~/.config/nvim/session/.vim

# TODO: alias for cleaning up the sessions. 

# TODO: aliases for config commands.
