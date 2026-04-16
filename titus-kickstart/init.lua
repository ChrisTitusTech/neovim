-- [[ Globals & Bootstrap ]]
-- Leader must be set before lazy.nvim loads plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.loader.enable() -- Lua bytecode cache for faster startup
vim.g.have_nerd_font = true -- set true if a Nerd Font is active in your terminal

-- [[ Options ]]
-- See :help option-list for the full list
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end) -- deferred to avoid startup slowdown
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
vim.o.conceallevel = 2
vim.o.smoothscroll = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = false

-- [[ Keymaps ]]
-- Additional keymaps live in lua/keymaps.lua
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- [[ Plugin Manager Bootstrap ]]
-- Installs lazy.nvim automatically on first run. Run :Lazy to manage plugins.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  { -- Keybind hint popup
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- [[ LSP ]]
  -- lazydev provides Neovim API types & completions for Lua config files
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} }, -- must load before dependents
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} }, -- LSP status notifications
      'saghen/blink.cmp',
    },
    config = function()
      -- Runs every time an LSP attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('snacks').picker.lsp_references, '[G]oto [R]eferences')
          map('gri', require('snacks').picker.lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('snacks').picker.lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration') -- declaration, not definition
          map('gO', require('snacks').picker.lsp_symbols, 'Open Document Symbols')
          map('gW', require('snacks').picker.lsp_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('snacks').picker.lsp_type_definitions, '[G]oto [T]ype Definition')

          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            return client:supports_method(method, bufnr)
          end

          -- Highlight references of symbol under cursor on hold; clear on move
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
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

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
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
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Add/remove servers here. See :help lspconfig-all for available servers.
      -- Each entry accepts: cmd, filetypes, capabilities, settings overrides.
      local servers = {
        -- clangd = {}, gopls = {}, pyright = {}, rust_analyzer = {}, ts_ls = {}
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Install servers + tools via Mason. Open :Mason to manage manually.
      local ensure_installed = vim.tbl_keys(servers or {})
      local lsp_to_mason = {
        lua_ls = 'lua-language-server',
        -- pyright = 'pyright', ts_ls = 'typescript-language-server',
      }
      for i, server_name in ipairs(ensure_installed) do
        if lsp_to_mason[server_name] then ensure_installed[i] = lsp_to_mason[server_name] end
      end
      vim.list_extend(ensure_installed, { 'stylua' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for server_name, server_config in pairs(servers) do
        local server = vim.tbl_deep_extend('force', {}, server_config)
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config[server_name] = server
        vim.lsp.enable(server_name)
      end
    end,
  },

  -- [[ Formatting ]]
  { -- Autoformat on save; <leader>f to format manually
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disabled for c/cpp which lack a standardized style
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return { timeout_ms = 500, lsp_format = 'fallback' }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- python = { 'isort', 'black' },
        -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  -- [[ Completion ]]
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      'giuxtaposition/blink-cmp-copilot',
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      -- Preset options: 'default' | 'super-tab' | 'enter' | 'none'
      -- See :h blink-cmp-config-keymap
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'copilot' },
        providers = {
          copilot = { name = 'copilot', module = 'blink-cmp-copilot', score_offset = 100 },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' }, -- downloads prebuilt Rust binary
      signature = { enabled = true },
    },
  },

  {
    'scottmckendry/cyberdream.nvim',
    priority = 1000, -- Load colorscheme before all other start plugins.
    config = function()
      vim.cmd.colorscheme 'cyberdream'
    end,
  },

  -- [[ UI ]]
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- mini.ai, mini.surround, mini.statusline
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },

  { -- Syntax highlighting and code navigation via tree-sitter
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' }, -- required for Ruby indent rules
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  -- Optional kickstart modules (uncomment to enable):
  -- require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns',

  -- Custom plugins live in lua/custom/plugins/
  { import = 'custom.plugins' },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip', 'matchit', 'matchparen', 'netrwPlugin', 'tarPlugin', 'tohtml', 'tutor', 'zipPlugin',
      },
    },
  },
  checker = { enabled = false },
  change_detection = { enabled = false },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

require 'keymaps'

-- [[ Post-setup ]]
-- Hide Copilot inline suggestions when blink.cmp menu is open
vim.api.nvim_create_autocmd('User', {
  pattern = 'CopilotAttached',
  callback = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuClose',
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
