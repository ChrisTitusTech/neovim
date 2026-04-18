#!/bin/bash

set -e

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

# Linux dependency repair script (safe to run repeatedly)
gitpath=$(pwd)

# Ensure helper directories and Neovim config link exist.
mkdir -p "$HOME/.vim/undodir"
mkdir -p "$HOME/.scripts"

target_nvim="$gitpath/titus-kickstart"
config_nvim="$HOME/.config/nvim"

if [ -L "$config_nvim" ]; then
    link_target=$(readlink "$config_nvim")
    if [ "$link_target" != "$target_nvim" ]; then
        rm -f "$config_nvim"
        ln -s "$target_nvim" "$config_nvim"
    fi
elif [ -e "$config_nvim" ]; then
    echo -e "${YELLOW}$config_nvim exists and is not a symlink. Leaving it untouched.${RC}"
    echo -e "${YELLOW}Remove it manually if you want this script to recreate the symlink.${RC}"
else
    ln -s "$target_nvim" "$config_nvim"
fi

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
            sudo apt install -y markdownlint-cli2 || sudo apt install -y node-markdownlint-cli2 || true
            ;;
        fedora)
            sudo dnf install ripgrep fd-find fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks golang ShellCheck libwebp-tools nodejs npm make -y
            sudo dnf install -y markdownlint-cli2 || sudo dnf install -y nodejs-markdownlint-cli2 || true
            ;;
        arch|manjaro)
            sudo pacman -S --needed ripgrep fd fzf $CLIPBOARD_PKG neovim python-virtualenv luarocks go shellcheck libwebp nodejs npm make --noconfirm
            sudo pacman -S --needed markdownlint-cli2 --noconfirm || true
            ;;
        opensuse)
            sudo zypper install ripgrep fd fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks go ShellCheck libwebp-tools nodejs npm make -y
            sudo zypper install -y markdownlint-cli2 || sudo zypper install -y nodejs-markdownlint-cli2 || true
            ;;
        *)
            echo -e "${YELLOW}Unsupported OS. Please install the following packages manually:${RC}"
            echo "ripgrep, fd, fzf, $CLIPBOARD_PKG, neovim, python3-virtualenv (or equivalent), luarocks, go, shellcheck, webp (cwebp), nodejs, npm, make"
            ;;
    esac

    # nvim-lint uses markdownlint-cli2 for Markdown files.
    if ! command -v markdownlint-cli2 >/dev/null 2>&1; then
        if command -v npm >/dev/null 2>&1; then
            sudo npm install -g markdownlint-cli2
        else
            echo -e "${YELLOW}npm not found. Install markdownlint-cli2 manually to enable Markdown linting.${RC}"
        fi
    fi

    echo -e "${GREEN}Dependency check complete.${RC}"
else
    echo -e "${RED}Unable to determine OS. Please install required packages manually.${RC}"
fi
