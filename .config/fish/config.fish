set -x SHELL /bin/bash

starship init fish | source

alias rng "ranger"
alias lzg "lazygit"

alias ll "exa -las type --git --icons"

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.bun/bin:$HOME/Library/Android/sdk/platform-tools:$PATH"

fish_vi_key_bindings
fzf --fish | source
