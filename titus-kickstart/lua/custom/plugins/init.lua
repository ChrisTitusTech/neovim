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
  'scottmckendry/cyberdream.nvim',
  'lunarvim/synthwave84.nvim',
  'emacs-grammarly/lsp-grammarly',
  -- vim-illuminate and true-zen = :lua Snacks.zen() I dont actually hate it for writing.
  -- Titus Custom
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      default = {
        dir_path = '/home/titus/github/website/static/images/2025/',
        extension = 'webp',
        template = '![$FILE_NAME_NO_EXT](/images/2025/$FILE_NAME)',
        relative_template_path = false,
      },
      filetypes = {
        markdown = {
          template = '![$FILE_NAME_NO_EXT](/images/2025/$FILE_NAME)',
        },
      },
    },
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
}
