-- Completion: blink.cmp, LuaSnip, Copilot, CopilotChat.

-- Build hooks must be registered before vim.pack.add() is called.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'LuaSnip' and (kind == 'install' or kind == 'update') then
      if vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
        vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path })
      end
    end
    if name == 'CopilotChat.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'make', 'tiktoken' }, { cwd = ev.data.path })
    end
  end,
})

vim.pack.add({
  -- Completion engine
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
  'https://github.com/giuxtaposition/blink-cmp-copilot',
  -- Snippets
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range('2.x') },
  -- Neovim Lua API completions
  'https://github.com/folke/lazydev.nvim',
  -- GitHub Copilot (suggestions fed through blink.cmp)
  'https://github.com/zbirenbaum/copilot.lua',
  -- Copilot Chat
  { src = 'https://github.com/nvim-lua/plenary.nvim', version = 'master' },
  'https://github.com/CopilotC-Nvim/CopilotChat.nvim',
})

-- lazydev: Neovim Lua API types & completions for Lua config files
require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = 'snacks.nvim', words = { 'Snacks' } },
  },
}

-- LuaSnip
require('luasnip').setup {}

-- blink.cmp
--- @module 'blink.cmp'
--- @type blink.cmp.Config
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev', 'copilot' },
    providers = {
      copilot = { name = 'copilot', module = 'blink-cmp-copilot', score_offset = 100 },
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}

-- Copilot (inline suggestions disabled; fed through blink.cmp)
require('copilot').setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = {
    markdown = true,
    yaml = true,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ['.'] = false,
  },
}

-- CopilotChat
require('CopilotChat').setup {
  model = 'auto',
  resources = { 'buffer:listed' },
  window = { layout = 'vertical', width = 0.4 },
  auto_insert_mode = true,
}

local map = vim.keymap.set
map({ 'n', 'v' }, '<leader>cc', function() require('CopilotChat').toggle() end, { desc = '[C]opilot [C]hat toggle' })
map({ 'n', 'v' }, '<leader>cq', function()
  local input = vim.fn.input 'Quick Chat: '
  if input ~= '' then
    require('CopilotChat').ask(input, { resources = 'selection' })
  end
end, { desc = '[C]opilot [Q]uick Chat' })
map('n', '<leader>cp', '<cmd>CopilotChatPrompts<CR>', { desc = '[C]opilot [P]rompts' })
map('n', '<leader>cm', '<cmd>CopilotChatModels<CR>', { desc = '[C]opilot [M]odels' })
map('n', '<leader>cr', '<cmd>CopilotChatReset<CR>', { desc = '[C]opilot [R]eset chat' })

-- Hide Copilot inline suggestions when blink.cmp menu is open
vim.api.nvim_create_autocmd('User', {
  pattern = 'CopilotAttached',
  callback = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      callback = function() vim.b.copilot_suggestion_hidden = true end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuClose',
      callback = function() vim.b.copilot_suggestion_hidden = false end,
    })
  end,
})
