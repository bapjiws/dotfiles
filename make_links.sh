#!/bin/bash
DOTFILES_FOLDER=~/Git/dotfiles/.config
ORIGINAL_FOLDER=~/.config

ln -sf $DOTFILES_FOLDER/nvim $ORIGINAL_FOLDER/nvim

ln -sf $DOTFILES_FOLDER/fish/conf.d/fnm.fish $ORIGINAL_FOLDER/fish/conf.d/fnm.fish

ln -sf $DOTFILES_FOLDER/fish/config.fish $ORIGINAL_FOLDER/fish/config.fish
ln -sf $DOTFILES_FOLDER/fish/functions/nvm.fish $ORIGINAL_FOLDER/fish/functions/nvm.fish

ln -sf $DOTFILES_FOLDER/fish/starship.toml $ORIGINAL_FOLDER/starship.toml

ln -sf $DOTFILES_FOLDER/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml

ln -sf $DOTFILES_FOLDER/ranger/rc.conf $ORIGINAL_FOLDER/ranger/rc.conf
ln -sf $DOTFILES_FOLDER/ranger/rifle.conf $ORIGINAL_FOLDER/ranger/rifle.conf
