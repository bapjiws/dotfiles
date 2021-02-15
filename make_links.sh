#!/bin/bash
DOTFILES_FOLDER=~/Git/dotfiles/.config
ORIGINAL_FOLDER=~/.config

PLUGIN_FOLDER=nvim/plugin

ln -sf $DOTFILES_FOLDER/nvim/init.vim $ORIGINAL_FOLDER/nvim/init.vim
ln -sf $DOTFILES_FOLDER/.zshrc ~/.zshrc
ln -sf $DOTFILES_FOLDER/ranger/rc.conf $ORIGINAL_FOLDER/ranger/rc.conf
ln -sf $DOTFILES_FOLDER/UltiSnips/javascript.snippets $ORIGINAL_FOLDER/nvim/UltiSnips/javascript.snippets

mkdir $ORIGINAL_FOLDER/$PLUGIN_FOLDER

for file in $(ls $DOTFILES_FOLDER/$PLUGIN_FOLDER)
do
  ln -sf $DOTFILES_FOLDER/$PLUGIN_FOLDER/$file $ORIGINAL_FOLDER/$PLUGIN_FOLDER/$file
done
