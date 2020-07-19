#!/bin/bash
GIT_FOLDER="~/Git/dotfiles/.config"
ORIGINAL_FOLDER="~/.config"

#-ln -s ~/Git/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim
bash -c "ln -sf $GIT_FOLDER/nvim/init.vim $ORIGINAL_FOLDER/nvim/init.vim"
