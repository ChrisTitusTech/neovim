#!/bin/bash

# Initial Setup file for new systems
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
gitpath=$(pwd)
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
mkdir -p "$HOME/.vim/undodir"
mkdir -p "$HOME/.scripts"
cp "$gitpath/.ignore" "$HOME/.ignore"
cp "$gitpath/tinypng" "$HOME/.scripts/tinypng"
cp uca.xml "$HOME/.config/Thunar/"
ln -s "$gitpath/custom" "$HOME/.config/nvim"
# Share system clipboard with unnamedplus
sudo apt install vim-gtk3 ripgrep fd-find xclip neovim python3-venv luarocks golang-go shellcheck -y
