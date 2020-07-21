#!/bin/bash
GIT_FOLDER=~/Git/dotfiles/.config
ORIGINAL_FOLDER=~/.config

PLUGIN_CONFIG_FOLDER=nvim/plugin-config

ln -sf $GIT_FOLDER/nvim/init.vim $ORIGINAL_FOLDER/nvim/init.vim

for file in $(ls $GIT_FOLDER/$PLUGIN_CONFIG_FOLDER)
do
  ln -sf $GIT_FOLDER/$PLUGIN_CONFIG_FOLDER/$file $ORIGINAL_FOLDER/$PLUGIN_CONFIG_FOLDER/$file
done
