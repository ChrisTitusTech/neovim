-- Treesitter context UI on top of Neovim 0.12 built-in treesitter.

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
})

require('treesitter-context').setup { max_lines = 3 }