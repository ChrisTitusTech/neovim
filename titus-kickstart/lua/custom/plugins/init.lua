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
  --
  -- alpha dashboard = https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md configure it urself
  -- telescope-zoxide  = :lua Snacks.picker.zoxide(opts?)
  -- Colorschemes
  'lunarvim/darkplus.nvim',
  'arcticicestudio/nord-vim',
  'lunarvim/synthwave84.nvim',
  'emacs-grammarly/lsp-grammarly',
  -- vim-illuminate and true-zen = :lua Snacks.zen() I dont actually hate it for writing.
  -- Titus Custom
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      dir_path = 'content/images/%y/',
      extension = 'webp', -- Fixed typo: was 'extention'
      filename = function()
        vim.fn.inputsave()
        local name = vim.fn.input 'Name: '
        vim.fn.inputrestore()

        if name == nil or name == '' then
          return os.date '%y-%m-%d-%H-%M-%S'
        end
        return name
      end,
    },
  },
  'mbbill/undotree',
  'wakatime/vim-wakatime',
  {
    'Pocco81/auto-save.nvim', -- seriously, fuck this. It should just be like 6 lines of lua or something.
    config = function()
      require('auto-save').setup {
        -- your config goes here
        -- or just leave it empty :)
      }
    end,
  },
  'lambdalisue/suda.vim',
  'github/copilot.vim',
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
  'ionide/Ionide-vim',
}
