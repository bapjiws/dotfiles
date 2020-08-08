#!/bin/bash
GIT_FOLDER=~/Git/dotfiles/.config
ORIGINAL_FOLDER=~/.config

PLUGIN_CONFIG_FOLDER=nvim/plugin-config
THEME_CONFIG_FOLDER=nvim/themes

ln -sf $GIT_FOLDER/nvim/init.vim $ORIGINAL_FOLDER/nvim/init.vim

for file in $(ls $GIT_FOLDER/$PLUGIN_CONFIG_FOLDER)
do
  ln -sf $GIT_FOLDER/$PLUGIN_CONFIG_FOLDER/$file $ORIGINAL_FOLDER/$PLUGIN_CONFIG_FOLDER/$file
done

for file in $(ls $GIT_FOLDER/$THEME_CONFIG_FOLDER)
do
  ln -sf $GIT_FOLDER/$THEME_CONFIG_FOLDER/$file $ORIGINAL_FOLDER/$THEME_CONFIG_FOLDER/$file
done
