#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

# Initial Setup file for new systems
gitpath=$(pwd)

rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim

# Setup Neovim config and link to linuxtoolbox
mkdir -p "$HOME/.vim/undodir"
mkdir -p "$HOME/.scripts"
ln -s "$gitpath/titus-kickstart" "$HOME/.config/nvim"

# Share system clipboard with unnamedplus
if [ -f /etc/os-release ]; then
    . /etc/os-release
    # Determine if Wayland or Xorg is being used
    if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
        CLIPBOARD_PKG="wl-clipboard"
    else
        CLIPBOARD_PKG="xclip"
    fi

    case "${ID_LIKE:-$ID}" in
        debian|ubuntu)
            sudo apt install ripgrep fd-find $CLIPBOARD_PKG python3-venv luarocks golang-go shellcheck -y
            ;;
        fedora)
            sudo dnf install ripgrep fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks golang ShellCheck -y
            ;;
        arch|manjaro)
            sudo pacman -S ripgrep fzf $CLIPBOARD_PKG neovim python-virtualenv luarocks go shellcheck --noconfirm
            ;;
        opensuse)
            sudo zypper install ripgrep fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks go ShellCheck -y
            ;;
        *)
            echo -e "${YELLOW}Unsupported OS. Please install the following packages manually:${RC}"
            echo "ripgrep, fzf, $CLIPBOARD_PKG, neovim, python3-virtualenv (or equivalent), luarocks, go, shellcheck"
            ;;
    esac
else
    echo -e "${RED}Unable to determine OS. Please install required packages manually.${RC}"
fi
