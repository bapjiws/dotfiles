#!/bin/bash
DOTFILES_FOLDER=~/Git/dotfiles/.config
ORIGINAL_FOLDER=~/.config

ln -sf $DOTFILES_FOLDER/nvim $ORIGINAL_FOLDER/nvim
ln -sf $DOTFILES_FOLDER/UltiSnips/javascript.snippets $ORIGINAL_FOLDER/nvim/UltiSnips/javascript.snippets

ln -sf $DOTFILES_FOLDER/ranger/rc.conf $ORIGINAL_FOLDER/ranger/rc.conf
ln -sf $DOTFILES_FOLDER/fish/config.fish $ORIGINAL_FOLDER/fish/config.fish
ln -sf $DOTFILES_FOLDER/starship.toml $ORIGINAL_FOLDER/starship.toml
