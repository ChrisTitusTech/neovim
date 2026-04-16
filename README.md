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

## Troubleshooting

### Markdown lint still shows ENOENT

1. Re-run the dependency repair script for your OS.
2. Confirm the binary exists in your shell:

```bash
command -v markdownlint-cli2
```

```powershell
Get-Command markdownlint-cli2
```

3. In Neovim, confirm it is visible on Neovim's PATH:

```vim
:echo exepath('markdownlint-cli2')
```

If this returns an empty string, Neovim is not seeing your shell PATH.

### npm global bin not on PATH

If `npm install -g markdownlint-cli2` succeeds but the command is still missing, your npm global bin path may not be in PATH.

Check npm global bin location:

```bash
npm bin -g
```

```powershell
npm prefix -g
```

Add that directory (or `<prefix>/bin` on Linux) to PATH, then restart terminal and Neovim.

### Winget install issues on Windows

If a package install fails:

1. Update winget sources:

```powershell
winget source update
```

2. Re-run [win-depend.ps1](win-depend.ps1).
3. If a package is still unavailable by ID, install it manually and re-run the script.

### Symlink not updated

The scripts do not delete a real directory at your Neovim config path.
If you previously created a normal directory there, remove or rename it manually, then re-run:

- [lin-depend.sh](lin-depend.sh)
- [win-depend.ps1](win-depend.ps1)

## Full Configuration Reference

For complete requirements, keymaps, plugins, and layout details, see:

- [titus-kickstart/GUIDE.md](titus-kickstart/GUIDE.md)
