#!/bin/bash

set -e

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
            sudo apt update
            sudo apt install ripgrep fd-find fzf neovim $CLIPBOARD_PKG python3-venv luarocks golang-go shellcheck webp nodejs npm make -y
            ;;
        fedora)
            sudo dnf install ripgrep fd-find fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks golang ShellCheck libwebp-tools nodejs npm make -y
            ;;
        arch|manjaro)
            sudo pacman -S ripgrep fd fzf $CLIPBOARD_PKG neovim python-virtualenv luarocks go shellcheck libwebp nodejs npm make --noconfirm
            ;;
        opensuse)
            sudo zypper install ripgrep fd fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks go ShellCheck libwebp-tools nodejs npm make -y
            ;;
        *)
            echo -e "${YELLOW}Unsupported OS. Please install the following packages manually:${RC}"
            echo "ripgrep, fd, fzf, $CLIPBOARD_PKG, neovim, python3-virtualenv (or equivalent), luarocks, go, shellcheck, webp (cwebp), nodejs, npm, make"
            ;;
    esac

    # nvim-lint uses markdownlint-cli2 for Markdown files.
    if command -v npm >/dev/null 2>&1; then
        if ! command -v markdownlint-cli2 >/dev/null 2>&1; then
            sudo npm install -g markdownlint-cli2
        fi
        # Copy markdownlint configuration to home directory for global use
        if [ -f "$gitpath/.markdownlint-cli2.yaml" ]; then
            cp "$gitpath/.markdownlint-cli2.yaml" "$HOME/.markdownlint-cli2.yaml"
            echo -e "${GREEN}Copied .markdownlint-cli2.yaml to home directory${RC}"
        fi
    else
        echo -e "${YELLOW}npm not found. Install markdownlint-cli2 manually to enable Markdown linting.${RC}"
    fi
else
    echo -e "${RED}Unable to determine OS. Please install required packages manually.${RC}"
fi
