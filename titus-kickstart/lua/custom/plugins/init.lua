-- All custom plugins. Simple/minimal-config plugins are at the top.
-- Plugins with complex configuration live under [[ Advanced Configuration ]] below.
return {

  -- ============================================================
  -- [[ Simple Plugins ]]
  -- ============================================================
  'NMAC427/guess-indent.nvim', -- auto-detect tabstop/shiftwidth
  'rebelot/kanagawa.nvim', -- alternate colorscheme
  'lunarvim/synthwave84.nvim', -- alternate colorscheme
  'emacs-grammarly/lsp-grammarly', -- Grammarly LSP for prose
  'mbbill/undotree', -- persistent undo history tree (mapped to <F5>)
  'wakatime/vim-wakatime', -- WakaTime coding time tracker
  'lambdalisue/suda.vim', -- edit files as sudo (:SudaWrite)
  'ionide/Ionide-vim', -- F# language support
  { 'mg979/vim-visual-multi', branch = 'master' }, -- multi-cursor (Ctrl+N)

  -- Simple opts-only plugins
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { 'nvim-treesitter/nvim-treesitter-context', opts = { max_lines = 3 } },
  { 'brenoprata10/nvim-highlight-colors', opts = { render = 'background' } },
  { 'Pocco81/auto-save.nvim', opts = {} },

  -- ============================================================
  -- [[ Colorscheme ]] (priority = 1000 so it loads first)
  -- ============================================================
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- Make floating windows stand out
            NormalFloat = { bg = theme.ui.bg_dim },
            FloatBorder = { fg = theme.ui.special, bg = theme.ui.bg_dim },
            FloatTitle = { fg = theme.ui.special, bold = true },

            -- Bolder keywords and types
            ['@keyword'] = { fg = theme.syn.keyword, bold = true },
            ['@type.builtin'] = { fg = theme.syn.type, bold = true },
            ['@function'] = { fg = theme.syn.fun, bold = true },
            ['@constructor'] = { fg = theme.syn.fun },

            -- Make strings and comments more distinct
            ['@string'] = { fg = theme.syn.string, italic = true },
            Comment = { fg = theme.syn.comment, italic = true },

            -- Brighten constants and numbers
            ['@constant'] = { fg = theme.syn.constant, bold = true },
            ['@number'] = { fg = theme.syn.number, bold = true },

            -- Popup menu
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.special },

            -- Make telescope pop
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopeBorderNormal = { fg = theme.ui.bg_p2, bg = theme.ui.bg_m1 },
          }
        end,
      }
      require('kanagawa').load 'wave'
    end,
  },

  -- ============================================================
  -- [[ Advanced Configuration ]]
  -- ============================================================

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
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  { -- Neovim Lua API types & completions for Lua config files
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },

  { -- LSP: server configs, Mason installer, diagnostic UI
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
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
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
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
          format = function(d)
            return d.message
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Add servers here. See :help lspconfig-all for the full list.
      local servers = {
        -- clangd = {}, gopls = {}, pyright = {}, rust_analyzer = {}, ts_ls = {}
        lua_ls = {
          settings = { Lua = { completion = { callSnippet = 'Replace' } } },
        },
      }

      local lsp_to_mason = {
        lua_ls = 'lua-language-server',
        -- pyright = 'pyright', ts_ls = 'typescript-language-server',
      }
      local ensure_installed = vim.tbl_keys(servers or {})
      for i, name in ipairs(ensure_installed) do
        if lsp_to_mason[name] then
          ensure_installed[i] = lsp_to_mason[name]
        end
      end
      vim.list_extend(ensure_installed, { 'stylua' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, cfg in pairs(servers) do
        local server = vim.tbl_deep_extend('force', {}, cfg)
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config[name] = server
        vim.lsp.enable(name)
      end
    end,
  },

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
    },
  },

  { -- Completion engine with Copilot + LuaSnip sources
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      'giuxtaposition/blink-cmp-copilot',
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
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
    },
  },

  { -- mini.ai (text objects), mini.surround, mini.statusline
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  { -- Syntax highlighting, code-aware folding, text objects
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' } },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  { -- File manager as a buffer (edit filesystem like text); `-` to open
    'stevearc/oil.nvim',
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    config = function()
      local oil = require 'oil'
      oil.setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-l>'] = false,
          ['<C-j>'] = false,
          ['<M-h>'] = 'actions.select_split',
        },
        view_options = { show_hidden = true },
      }
      vim.keymap.set('n', '-', oil.open, { desc = 'Open parent directory (oil)' })
      vim.keymap.set('n', '<leader>o', oil.toggle_float, { desc = 'Toggle oil float' })
    end,
  },

  { -- Paste images from clipboard into Markdown (<leader>p)
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = function()
      local year = os.date '%Y'
      return {
        default = {
          dir_path = '/home/titus/github/website/static/images/' .. year .. '/',
          extension = 'webp',
          process_cmd = 'cwebp -q 80 "$FILE_PATH" -o "$FILE_PATH" 2>/dev/null',
          template = '![$FILE_NAME_NO_EXT](/images/' .. year .. '/$FILE_NAME)',
          relative_template_path = false,
        },
        filetypes = {
          markdown = { template = '![$FILE_NAME_NO_EXT](/images/' .. year .. '/$FILE_NAME)' },
        },
      }
    end,
  },

  { -- Smart comment toggling (<leader>/)
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },

  { -- Dashboard / start screen (<leader>a)
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local startify = require 'alpha.themes.startify'
      startify.file_icons.provider = 'devicons'
      require('alpha').setup(startify.config)
    end,
  },

  { -- GitHub Copilot (suggestions fed through blink.cmp, not inline)
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
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
    end,
  },

  { -- VSCode-style buffer tab bar
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        offsets = { { filetype = 'snacks_layout_box', text = 'Explorer' } },
        separator_style = 'slant',
        always_show_bufferline = true,
        enforce_regular_tabs = true,
      },
      highlights = {
        buffer_selected = { bold = true, italic = false },
        indicator_selected = { bold = true },
      },
    },
    keys = {
      { '<S-l>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
      { '<leader>x', '<cmd>bdelete<CR>', desc = 'Close buffer' },
    },
  },

  { -- Integrated terminal toggled with Ctrl+` (like VSCode)
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      {
        '<C-`>',
        function()
          local dir = vim.fn.expand '%:p:h'
          if dir == '' or vim.fn.isdirectory(dir) == 0 then
            local cwd = vim.uv.cwd()
            dir = cwd or '.'
          end
          vim.cmd('ToggleTerm dir=' .. vim.fn.fnameescape(dir))
        end,
        mode = 'n',
        desc = 'Toggle terminal (buffer directory)',
      },
    },
    opts = {
      size = 15,
      direction = 'horizontal',
      shade_terminals = true,
    },
  },

  { -- Problems panel (<leader>xx), like VSCode Ctrl+Shift+M
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics' },
      { '<leader>cs', '<cmd>Trouble symbols toggle<CR>', desc = 'Symbols (Trouble)' },
    },
    opts = {},
  },

  { -- Symbol outline sidebar, like VSCode outline panel (<leader>ao)
    'stevearc/aerial.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>ao', '<cmd>AerialToggle!<CR>', desc = 'Toggle [A]erial [O]utline' },
    },
    opts = {},
  },

  { -- GitHub Copilot Chat (<leader>cc opens chat, <leader>cq quick chat)
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      model = 'auto',
      window = { layout = 'vertical', width = 0.4 },
      auto_insert_mode = true,
    },
    keys = {
      {
        '<leader>cc',
        function()
          require('CopilotChat').toggle { resources = 'buffer' }
        end,
        mode = { 'n', 'v' },
        desc = '[C]opilot [C]hat toggle',
      },
      {
        '<leader>cq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input, { resources = 'selection' })
          end
        end,
        mode = { 'n', 'v' },
        desc = '[C]opilot [Q]uick Chat',
      },
      { '<leader>cp', '<cmd>CopilotChatPrompts<CR>', desc = '[C]opilot [P]rompts' },
      { '<leader>cm', '<cmd>CopilotChatModels<CR>', desc = '[C]opilot [M]odels' },
      { '<leader>cr', '<cmd>CopilotChatReset<CR>', desc = '[C]opilot [R]eset chat' },
    },
  },
}
