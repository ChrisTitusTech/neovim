-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- File Explorer I'll force you to use oil or use mini.files, if you desperatly want an tree viewer just use Snacks.explorer().
  {
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
        view_options = {
          show_hidden = true,
        },
      }

      vim.keymap.set('n', '-', oil.open, { desc = 'Open parent directory with oil' })
      vim.keymap.set('n', '<leader>o', oil.toggle_float)
    end,
  },
  'lunarvim/synthwave84.nvim',
  'emacs-grammarly/lsp-grammarly',
  -- vim-illuminate and true-zen = :lua Snacks.zen() I dont actually hate it for writing.
  -- Titus Custom
  {
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
          markdown = {
            template = '![$FILE_NAME_NO_EXT](/images/' .. year .. '/$FILE_NAME)',
          },
        },
      }
    end,
  },
  'mbbill/undotree',
  'wakatime/vim-wakatime',
  {
    'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup {
        -- your config goes here
        -- or just leave it empty :)
      }
    end,
  },
  'lambdalisue/suda.vim',
  --  'github/copilot.vim',
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
  'ionide/Ionide-vim',
  {
    'greggh/claude-code.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required for git operations
    },
    config = function()
      require('claude-code').setup()
    end,
  },
  {
    'goolord/alpha-nvim',
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local startify = require 'alpha.themes.startify'
      -- available: devicons, mini, default is mini
      -- if provider not loaded and enabled is true, it will try to use another provider
      startify.file_icons.provider = 'devicons'
      require('alpha').setup(startify.config)
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false }, -- Disable suggestions since we're using blink.cmp
        panel = { enabled = false },      -- Disable panel since we're using blink.cmp
        filetypes = {
          markdown = true,
          yaml = true,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      }
    end,
  },

  -- VSCode-style tab bar
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        offsets = { { filetype = 'snacks_layout_box', text = 'Explorer' } },
      },
    },
    keys = {
      { '<S-l>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
      { '<leader>x', '<cmd>bdelete<CR>', desc = 'Close buffer' },
    },
  },

  -- Integrated terminal (Ctrl+` like VSCode)
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      size = 15,
      open_mapping = [[<C-`>]],
      direction = 'horizontal',
      shade_terminals = true,
    },
  },

  -- Problems panel (like VSCode Ctrl+Shift+M)
  {
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics' },
      { '<leader>cs', '<cmd>Trouble symbols toggle<CR>', desc = 'Symbols (Trouble)' },
    },
    opts = {},
  },

  -- Sticky scroll (shows current function/class at top like VSCode)
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = { max_lines = 3 },
  },

  -- Symbol outline sidebar (like VSCode outline panel)
  {
    'stevearc/aerial.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>ao', '<cmd>AerialToggle!<CR>', desc = 'Toggle [A]erial [O]utline' },
    },
    opts = {},
  },

  -- Multi-cursor (Ctrl+N to select next, like VSCode Ctrl+D)
  { 'mg979/vim-visual-multi', branch = 'master' },

  -- Inline color swatches (#fff, rgb(), etc.)
  {
    'brenoprata10/nvim-highlight-colors',
    opts = { render = 'background' },
  },
}
