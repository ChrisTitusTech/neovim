#!/bin/bash

# Initial Setup file for new systems
gitpath=`pwd`
mkdir -p $HOME/.vim/undodir
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.scripts
curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s $gitpath/.ignore $HOME/.ignore
ln -s $gitpath/init.vim $HOME/.config/nvim/init.vim
ln -s $gitpath/tinypng $HOME/.scripts/tinypng

# Share system clipboard with unnamedplus
sudo apt install vim-gtk3 ripgrep fd-find xclip
