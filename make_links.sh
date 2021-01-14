#!/bin/bash
DOTFILES_FOLDER=~/Git/dotfiles/.config
ORIGINAL_FOLDER=~/.config

PLUGIN_CONFIG_FOLDER=nvim/plugin-config
THEME_CONFIG_FOLDER=nvim/themes

ln -sf $DOTFILES_FOLDER/nvim/init.vim $ORIGINAL_FOLDER/nvim/init.vim
ln -sf $DOTFILES_FOLDER/.zshrc ~/.zshrc
ln -sf $DOTFILES_FOLDER/ranger/rc.conf $ORIGINAL_FOLDER/ranger/rc.conf
ln -sf $DOTFILES_FOLDER/UltiSnips/javascript.snippets $ORIGINAL_FOLDER/nvim/UltiSnips/javascript.snippets

for file in $(ls $DOTFILES_FOLDER/$PLUGIN_CONFIG_FOLDER)
do
  ln -sf $DOTFILES_FOLDER/$PLUGIN_CONFIG_FOLDER/$file $ORIGINAL_FOLDER/$PLUGIN_CONFIG_FOLDER/$file
done

for file in $(ls $DOTFILES_FOLDER/$THEME_CONFIG_FOLDER)
do
  ln -sf $DOTFILES_FOLDER/$THEME_CONFIG_FOLDER/$file $ORIGINAL_FOLDER/$THEME_CONFIG_FOLDER/$file
done
