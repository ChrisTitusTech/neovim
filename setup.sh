#!/bin/bash

# Initial Setup file for new systems
gitpath=`pwd`
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
mkdir -p $HOME/.vim/undodir
mkdir -p $HOME/.scripts
ln -s $gitpath/.ignore $HOME/.ignore
ln -s $gitpath/tinypng $HOME/.scripts/tinypng
cp uca.xml $HOME/.config/Thunar/
git clone https://github.com/NvChad/NvChad $HOME/.config/nvim --depth 1
ln -s $gitpath/custom $HOME/.config/nvim/lua/custom
# Share system clipboard with unnamedplus
sudo apt install vim-gtk3 ripgrep fd-find xclip neovim python3-venv luarocks go luarocks go
