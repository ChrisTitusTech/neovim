#!/bin/bash

# Initial Setup file for new systems
gitpath=$(pwd)
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
mkdir -p "$HOME/.vim/undodir"
mkdir -p "$HOME/.scripts"
mkdir -p "$HOME/.config/nvim"
ln -s "$gitpath/.ignore" "$HOME/.ignore"
ln -s "$gitpath/tinypng" "$HOME/.scripts/tinypng"
cp uca.xml "$HOME/.config/Thunar/"
ln -s "$gitpath/init.vim" "$HOME/.config/nvim/init.vim"
# Share system clipboard with unnamedplus
sudo apt install vim-gtk3 ripgrep fd-find xclip neovim python3-venv luarocks golang-go shellcheck
