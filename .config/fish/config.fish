set -x SHELL /bin/bash

starship init fish | source

alias rng "ranger"
alias lzg "lazygit"

alias ll "exa -las type --git --icons"

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.bun/bin:$HOME/Library/Android/sdk/platform-tools:$PATH"
export PATH="$HOME/Git/tt-go/scripts:$PATH"

export PATH="$HOME/.opencode/bin:$PATH"

fish_vi_key_bindings
fzf --fish | source

# Print tree structure in the preview window
# export FZF_ALT_C_OPTS="
#   --walker-skip .git,node_modules,target
#   --preview 'tree -C {}'"

# CTRL-Y to copy the command into clipboard using pbcopy
# export FZF_CTRL_R_OPTS="
#   --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
#   --color header:italic
#   --header 'Press CTRL-Y to copy command into clipboard'"

# Preview file content using bat (https://github.com/sharkdp/bat)
# export FZF_CTRL_T_OPTS="
#   --walker-skip .git,node_modules,target
#   --preview 'bat -n --color=always {}'
#   --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_T_COMMAND="fd --type d --type f --hidden --follow --exclude .git"

starship init fish | source
