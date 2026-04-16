# Titus's Neovim Adventure

This repo is my daily Neovim setup built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), with extra plugins and quality-of-life tooling layered on top.

## Quick Start

```bash
git clone https://github.com/ChrisTitusTech/neovim ~/.config/nvim
cd ~/.config/nvim
nvim
```

On first launch, Neovim will install plugins automatically via lazy.nvim.

## Dependency Repair Scripts

These scripts are safe to run any time to repair missing dependencies.
They do not wipe your Neovim data.

### Linux

```bash
bash lin-depend.sh
```

What it handles:
- Installs core CLI deps (ripgrep, fd, fzf, neovim, shellcheck, node/npm, make, etc.)
- Installs clipboard dependency based on session type (Wayland or X11)
- Ensures `markdownlint-cli2` is available for markdown linting
- Ensures your `~/.config/nvim` symlink points to `titus-kickstart`

### Windows (PowerShell)

```powershell
.\win-depend.ps1
```

What it handles:
- Installs core CLI deps via winget when missing
- Ensures `markdownlint-cli2` is installed via npm
- Ensures `%USERPROFILE%\AppData\Local\nvim` points at `titus-kickstart`

## Why markdownlint-cli2?

This config uses nvim-lint for Markdown and is configured for `markdownlint-cli2`.
If only `markdownlint` is installed, you may see ENOENT errors.

## Full Configuration Reference

For complete requirements, keymaps, plugins, and layout details, see:

- [titus-kickstart/GUIDE.md](titus-kickstart/GUIDE.md)
