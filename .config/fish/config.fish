set -x SHELL /bin/bash

starship init fish | source

alias rng "ranger"
alias lzg "lazygit"

alias ll "exa -las type --git --icons"

export PATH="$HOME/.bun/bin:$HOME/Library/Android/sdk/platform-tools:$PATH"
