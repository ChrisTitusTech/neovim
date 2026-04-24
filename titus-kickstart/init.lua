-- [[ Globals & Bootstrap ]]
-- Leader must be set before plugin/ scripts are sourced
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.loader.enable() -- Lua bytecode cache for faster startup
vim.g.have_nerd_font = true -- set true if a Nerd Font is active in your terminal

if vim.g.neovide then
  local neovide_font_size = 12
  local font_candidates = {
    'MesloLGS NF',
    'JetBrainsMono Nerd Font',
    'JetBrainsMonoNL Nerd Font',
    'FiraCode Nerd Font',
    'Hack Nerd Font',
    'Noto Sans Mono',
    'Monospace',
  }

  local selected_font = font_candidates[#font_candidates]
  if vim.fn.executable 'fc-list' == 1 then
    local out = vim.fn.system({ 'fc-list', ':', 'family' })
    for _, font_name in ipairs(font_candidates) do
      if out:find(font_name, 1, true) then
        selected_font = font_name
        break
      end
    end
  else
    selected_font = font_candidates[1]
  end

  vim.o.guifont = string.format('%s:h%d', selected_font, neovide_font_size)
end

-- [[ Options ]]
-- See :help option-list for the full list
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end) -- deferred to avoid startup slowdown
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.pumblend = 10
vim.o.winblend = 10
vim.o.smoothscroll = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = false

-- [[ Keymaps ]]
-- All keymaps live in lua/keymaps.lua (loaded after plugins below)

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Plugins ]]
-- Plugin files live in plugin/ and are sourced automatically by Neovim.
-- Run :lua vim.pack.update() to update all plugins.

require 'keymaps'