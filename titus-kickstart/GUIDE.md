# Titus Kickstart — Neovim Config Guide

A VSCode-inspired Neovim configuration built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

---

## Requirements

- **Neovim 0.10+**
- **Git**
- A **Nerd Font** installed and set as your terminal font (e.g. [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)) — icons will be broken without one
- `make` (for blink.cmp's Rust fuzzy matching binary)
- Optional: `cwebp` (for image paste webp conversion)

---

## Installation

```bash
git clone https://github.com/ChrisTitusTech/neovim ~/.config/nvim
nvim  # lazy.nvim will auto-install all plugins on first launch
```

Run `:Lazy` to manage plugins, `:Mason` to manage LSP servers and tools.

---

## File Structure

```
titus-kickstart/
├── init.lua                        # Main config: options, keymaps, core plugins
├── lua/
│   ├── keymaps.lua                 # Additional keymaps
│   └── custom/
│       └── plugins/
│           ├── init.lua            # All custom/extra plugins
│           └── snacks.lua          # Snacks.nvim (picker, explorer, UI)
└── kickstart/
    └── plugins/                    # Optional kickstart modules (enabled/disabled in init.lua)
        ├── autopairs.lua
        ├── gitsigns.lua
        ├── indent_line.lua
        └── lint.lua
```

---

## Leader Key

The leader key is **`Space`**. All `<leader>` shortcuts below use it.

Press **`Space`** in normal mode and wait — **which-key** will show a popup of all available bindings.

---

## Keymaps

### Window Navigation

| Key | Action |
|-----|--------|
| `Ctrl+h` | Focus left window |
| `Ctrl+j` | Focus lower window |
| `Ctrl+k` | Focus upper window |
| `Ctrl+l` | Focus right window |
| `Ctrl+↑` | Resize window up |
| `Ctrl+↓` | Resize window down |
| `Ctrl+←` | Resize window left |
| `Ctrl+→` | Resize window right |

### Buffer / Tab Navigation

| Key | Action |
|-----|--------|
| `Shift+l` | Next buffer (bufferline) |
| `Shift+h` | Previous buffer (bufferline) |
| `<leader>x` | Close current buffer |
| `<leader>1`–`5` | Jump to tab 1–5 |
| `<leader>t` | New tab |
| `<leader>c` | Close tab |

### File Navigation

| Key | Action |
|-----|--------|
| `-` | Open parent directory in oil.nvim |
| `<leader>o` | Toggle oil.nvim float |
| `<leader>fe` | Open Snacks file explorer tree |
| `<leader>ff` | Smart file picker (recent + git files) |
| `<leader>sf` | Find files |
| `<leader>s.` | Recent files |
| `<leader>fp` | Browse projects |
| `<leader><leader>` | Switch open buffers |

### Search (Snacks Picker)

| Key | Action |
|-----|--------|
| `<leader>/` | Fuzzy search current buffer |
| `<leader>fg` | Live grep (search in files) |
| `<leader>sw` | Search word under cursor |
| `<leader>s/` | Grep across open buffers |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>sc` | Search commands |
| `<leader>sb` | Search builtins |
| `<leader>ss` | Select a Snacks picker |
| `<leader>sd` | Search diagnostics |
| `<leader>sr` | Resume last search |
| `<leader>sn` | Search Neovim config files |

### LSP (Language Server)

| Key | Action |
|-----|--------|
| `grn` | Rename symbol |
| `gra` | Code actions |
| `grr` | Go to references |
| `gri` | Go to implementation |
| `grd` | Go to definition |
| `grD` | Go to declaration |
| `grt` | Go to type definition |
| `gO` | Document symbols |
| `gW` | Workspace symbols |
| `<leader>th` | Toggle inlay hints |
| `<leader>q` | Open diagnostics quickfix list |
| `<leader>f` | Format buffer |

### Diagnostics & Code Navigation

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle Trouble (all diagnostics) |
| `<leader>xX` | Toggle Trouble (current buffer diagnostics) |
| `<leader>cs` | Toggle Trouble symbols view |
| `<leader>ao` | Toggle Aerial symbol outline |
| `<leader>sd` | Search diagnostics via picker |

### Terminal

| Key | Action |
|-----|--------|
| `Ctrl+\`` | Toggle integrated terminal |
| `Esc Esc` | Exit terminal mode (back to normal) |

### Editing

| Key | Action |
|-----|--------|
| `jj` | Exit insert mode (faster than `Esc`) |
| `<leader>/` | Toggle comment (normal) |
| `<leader>/` | Toggle comment (visual) |
| `>` / `<` | Indent/dedent and stay in visual mode |
| `p` (visual) | Paste without overwriting clipboard |
| `<leader>e` | Jump to end of line (`$`) |
| `S` | Start global search & replace (`:s//g`) |
| `Ctrl+N` | Multi-cursor: select next occurrence (vim-visual-multi) |

### Undo & History

| Key | Action |
|-----|--------|
| `F5` | Toggle Undotree (persistent undo history browser) |

### Git

| Key | Action |
|-----|--------|
| `<leader>h` | Git hunk group (which-key shows sub-bindings) |

Git diff signs appear in the sign column automatically via gitsigns.

### Utilities

| Key | Action |
|-----|--------|
| `<leader>p` | Paste image from clipboard (`img-clip`) |
| `<leader>a` | Open Alpha dashboard |
| `<leader>cc` | Open Claude Code |
| `Ctrl+\` | Toggle Zen mode |
| `Esc` (normal) | Clear search highlights |

---

## Plugins

### Core / LSP

| Plugin | Purpose |
|--------|---------|
| `neovim/nvim-lspconfig` | LSP client configuration |
| `mason-org/mason.nvim` | LSP/tool installer (`:Mason`) |
| `mason-tool-installer` | Auto-installs configured servers |
| `j-hui/fidget.nvim` | LSP progress spinner (bottom right) |
| `folke/lazydev.nvim` | Lua type hints for Neovim API |
| `saghen/blink.cmp` | Completion engine with fuzzy matching |
| `L3MON4D3/LuaSnip` | Snippet engine |
| `zbirenbaum/copilot.lua` | GitHub Copilot integration |
| `giuxtaposition/blink-cmp-copilot` | Copilot as a blink.cmp source |
| `stevearc/conform.nvim` | Auto-format on save |

### UI / Visual

| Plugin | Purpose |
|--------|---------|
| `scottmckendry/cyberdream.nvim` | Default color scheme |
| `lunarvim/synthwave84.nvim` | Alternate color scheme |
| `akinsho/bufferline.nvim` | VSCode-style buffer tabs |
| `echasnovski/mini.nvim` | Statusline, surround, text objects |
| `folke/which-key.nvim` | Keymap popup hints |
| `folke/todo-comments.nvim` | Highlights `TODO`, `FIXME`, `NOTE` etc. |
| `brenoprata10/nvim-highlight-colors` | Inline color swatches for hex/rgb values |
| `nvim-treesitter/nvim-treesitter-context` | Sticky scroll — shows current function at top |

### Navigation & Search

| Plugin | Purpose |
|--------|---------|
| `folke/snacks.nvim` | Picker, explorer, indent guides, notifier, zen, statuscolumn |
| `stevearc/oil.nvim` | File manager as a buffer (edit filesystem like text) |
| `stevearc/aerial.nvim` | Symbol outline sidebar |
| `folke/trouble.nvim` | Diagnostics/quickfix panel |

### Editor Enhancement

| Plugin | Purpose |
|--------|---------|
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting + code-aware folding |
| `NMAC427/guess-indent.nvim` | Auto-detect tab/space indentation |
| `mg979/vim-visual-multi` | Multi-cursor editing |
| `mbbill/undotree` | Visual undo history tree |
| `numToStr/Comment.nvim` | Smart comment toggling |
| `akinsho/toggleterm.nvim` | Integrated terminal |
| `Pocco81/auto-save.nvim` | Auto-save buffers |
| `lambdalisue/suda.vim` | Edit files as sudo (`:SudaWrite`) |

### Extras

| Plugin | Purpose |
|--------|---------|
| `HakonHarnes/img-clip.nvim` | Paste images from clipboard into markdown |
| `goolord/alpha-nvim` | Dashboard/start screen |
| `greggh/claude-code.nvim` | Claude AI integration |
| `wakatime/vim-wakatime` | WakaTime coding time tracker |
| `ionide/Ionide-vim` | F# language support |
| `emacs-grammarly/lsp-grammarly` | Grammarly LSP for prose |

---

## Adding LSP Servers

Open `:Mason` to browse and install servers manually, or add them to the `servers` table in `init.lua`:

```lua
local servers = {
  lua_ls = { ... },        -- already configured
  pyright = {},            -- Python
  ts_ls = {},              -- TypeScript/JavaScript
  rust_analyzer = {},      -- Rust
  gopls = {},              -- Go
  clangd = {},             -- C/C++
}
```

Add the Mason package name to `lsp_to_mason` if the names differ:

```lua
local lsp_to_mason = {
  lua_ls = 'lua-language-server',
  ts_ls  = 'typescript-language-server',
}
```

---

## Adding Formatters

Edit the `formatters_by_ft` table in the `conform.nvim` config in `init.lua`:

```lua
formatters_by_ft = {
  lua        = { 'stylua' },
  python     = { 'isort', 'black' },
  javascript = { 'prettierd', 'prettier', stop_after_first = true },
  typescript = { 'prettierd' },
},
```

Then install the formatter via Mason (`:Mason`) or ensure it is on your `$PATH`.

---

## Color Schemes

The default theme is **cyberdream**. To switch, change the `colorscheme` line in `init.lua`:

```lua
vim.cmd.colorscheme 'synthwave84'   -- alternate included theme
```

Or install any other theme and set it the same way.

---

## Changing the Nerd Font Setting

`vim.g.have_nerd_font` is set to `true` in `init.lua`. If you are not using a Nerd Font, set it to `false` — this disables icons and falls back to text labels throughout the UI.

---

## Plugin Management

| Command | Action |
|---------|--------|
| `:Lazy` | Open plugin manager UI |
| `:Lazy sync` | Update + install + clean plugins |
| `:Lazy update` | Update plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Lazy profile` | View startup performance |
| `:Mason` | Open LSP/tool installer |
| `:ConformInfo` | Check formatter status for current buffer |
| `:LspInfo` | Check LSP server status |
| `:checkhealth` | Full health check |

---

## Tips

- **Folding**: Folds are powered by treesitter and start open. Use `za` to toggle a fold, `zR` to open all, `zM` to close all.
- **Surround**: Use `mini.surround` — e.g. `sa` to add, `sd` to delete, `sr` to replace surroundings.
- **Text objects**: `mini.ai` extends default text objects — `a` and `i` work with functions, classes, arguments and more.
- **Sudo write**: Use `:SudaWrite` to save a file that requires sudo.
- **Image paste**: In a markdown file, copy an image to your clipboard and press `<leader>p` to paste and convert it to WebP automatically.
- **Zen mode**: Press `Ctrl+\` or run `:lua Snacks.zen()` for a distraction-free writing view.
- **Notifications**: Toast notifications appear via Snacks notifier. Run `:lua Snacks.notifier.show_history()` to see past messages.
