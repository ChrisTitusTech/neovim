#!/bin/bash

# Initial Setup file for new systems
gitpath=$(pwd)
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
mkdir -p "$HOME/.vim/undodir"
mkdir -p "$HOME/.scripts"
cp "$gitpath/.ignore" "$HOME/.ignore"
ln -s "$gitpath/titus-kickstart" "$HOME/.config/nvim"
# Share system clipboard with unnamedplus
sudo apt install vim-gtk3 ripgrep fd-find xclip neovim python3-venv luarocks golang-go shellcheck -y
