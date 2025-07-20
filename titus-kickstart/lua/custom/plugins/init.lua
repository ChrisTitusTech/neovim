-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- File Explorer in Vim Ctrl+f
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').load_extension('file_browser')
    end,
  },
  -- Use Ctrl+fp to list recent git projects
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
      })
      require('telescope').load_extension('projects')
    end,
  },
  -- alpha dashboard
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('alpha').setup(require('alpha.themes.startify').config)
    end,
  },
  {
    'jvgrootveld/telescope-zoxide',
    config = function()
      require('telescope').load_extension('zoxide')
    end,
  },
  -- Colorschemes
  'lunarvim/darkplus.nvim',
  'arcticicestudio/nord-vim',
  'lunarvim/synthwave84.nvim',
  'emacs-grammarly/lsp-grammarly',
  -- Quick word search under cursor alt+p and alt+n
  'RRethy/vim-illuminate',
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
    'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup({
        -- your config goes here
        -- or just leave it empty :)
      })
    end,
  },
  {
    'Pocco81/true-zen.nvim',
    config = function()
      require('true-zen').setup({
        -- your config goes here
        -- or just leave it empty :)
      })
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
}
