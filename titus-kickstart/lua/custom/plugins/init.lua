-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
-- File Explorer in Vim Ctrl+f
 {
 "nvim-telescope/telescope-file-browser.nvim",
 dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
 };
-- Use Ctrl+fp to list recent git projects
  "ahmedkhalf/project.nvim",
-- alpha dashboard
  {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
  end
  };
  "jvgrootveld/telescope-zoxide",
  -- Colorschemes
  "lunarvim/darkplus.nvim",
  "arcticicestudio/nord-vim",
  "emacs-grammarly/lsp-grammarly",
-- Quick word search under cursor alt+p and alt+n
  "RRethy/vim-illuminate",
-- Titus Custom
  "postfen/clipboard-image.nvim",
  "mbbill/undotree",
  "wakatime/vim-wakatime",
  "Pocco81/auto-save.nvim",
  "Pocco81/true-zen.nvim",
  "lambdalisue/suda.vim",
  "lunarvim/synthwave84.nvim",
  "github/copilot.vim",
  "numToStr/Comment.nvim",
}
