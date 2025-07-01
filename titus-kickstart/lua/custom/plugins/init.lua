-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- File Explorer in Vim Ctrl+f
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  },
  -- Use Ctrl+fp to list recent git projects
  'ahmedkhalf/project.nvim',
  -- alpha dashboard
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('alpha').setup(require('alpha.themes.startify').config)
    end,
  },
  'jvgrootveld/telescope-zoxide',
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
      extention = 'webp',
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
  'Pocco81/auto-save.nvim',
  'Pocco81/true-zen.nvim',
  'lambdalisue/suda.vim',
  'github/copilot.vim',
  'numToStr/Comment.nvim',
}
