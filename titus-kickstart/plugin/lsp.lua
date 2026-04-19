-- LSP: server configuration, Mason installer, formatter (conform), linting.

vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  { src = 'https://github.com/mason-org/mason.nvim', version = 'main' },
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  { src = 'https://github.com/j-hui/fidget.nvim', version = 'main' },
  -- Autoformat on save
  'https://github.com/stevearc/conform.nvim',
})

-- Mason
require('mason').setup {}

-- Fidget: LSP progress notifications
require('fidget').setup {}

-- Conform: autoformat
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    -- python     = { 'isort', 'black' },
    -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
  },
}
vim.keymap.set('', '<leader>=', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

-- LSP servers to configure
local servers = {
  -- clangd = {}, gopls = {}, pyright = {}, rust_analyzer = {}, ts_ls = {}
  lua_ls = {
    settings = { Lua = { completion = { callSnippet = 'Replace' } } },
  },
}

-- Map LSP server names to Mason package names where they differ
local lsp_to_mason = {
  lua_ls = 'lua-language-server',
  -- pyright = 'pyright', ts_ls = 'typescript-language-server',
}
local ensure_installed = vim.tbl_keys(servers)
for i, name in ipairs(ensure_installed) do
  if lsp_to_mason[name] then
    ensure_installed[i] = lsp_to_mason[name]
  end
end
vim.list_extend(ensure_installed, { 'stylua' })
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- Apply server configs and enable them
local capabilities = require('blink.cmp').get_lsp_capabilities()
for name, cfg in pairs(servers) do
  local server = vim.tbl_deep_extend('force', {}, cfg)
  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  vim.lsp.config[name] = server
  vim.lsp.enable(name)
end

-- LspAttach: keymaps and highlight on cursor
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grr', function() require('snacks').picker.lsp_references() end, '[G]oto [R]eferences')
    map('gri', function() require('snacks').picker.lsp_implementations() end, '[G]oto [I]mplementation')
    map('grd', function() require('snacks').picker.lsp_definitions() end, '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gO', function() require('snacks').picker.lsp_symbols() end, 'Open Document Symbols')
    map('gW', function() require('snacks').picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
    map('grt', function() require('snacks').picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')

    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer
    ---@return boolean
    local function client_supports_method(client, method, bufnr)
      return client:supports_method(method, bufnr)
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local hl_group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(d) return d.message end,
  },
}
