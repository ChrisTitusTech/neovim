#!/bin/bash

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# Initial Setup file for new systems
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
sudo apt install vim-gtk3 ripgrep fd-find xclip neovim python3-venv luarocks golang-go shellcheck
# vale smart text writing https://vale.sh/docs/vale-cli/installation/
nix-env -iA nixpkgs.vale
cp "$gitpath/.vale.ini" "$HOME/.vale.ini"
vale sync
