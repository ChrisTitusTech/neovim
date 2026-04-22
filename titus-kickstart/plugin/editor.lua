-- Editor utilities: autopairs, indent guides, linting, highlighting, auto-save,
-- guess-indent, todo-comments, img-clip, undotree, wakatime, suda, visual-multi,
-- grammarly LSP.

vim.pack.add({
  -- Autopairs
  'https://github.com/windwp/nvim-autopairs',
  -- Indent guides
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  -- Linting
  'https://github.com/mfussenegger/nvim-lint',
  -- Color highlighting
  'https://github.com/brenoprata10/nvim-highlight-colors',
  -- Auto-save
  'https://github.com/Pocco81/auto-save.nvim',
  -- Auto-detect tab/space indentation
  'https://github.com/NMAC427/guess-indent.nvim',
  -- Todo comment highlights
  'https://github.com/folke/todo-comments.nvim',
  -- Paste images from clipboard into Markdown
  'https://github.com/HakonHarnes/img-clip.nvim',
  -- Persistent undo history tree (mapped to <F5>)
  'https://github.com/mbbill/undotree',
  -- WakaTime coding time tracker
  'https://github.com/wakatime/vim-wakatime',
  -- Edit files as sudo (:SudaWrite)
  'https://github.com/lambdalisue/suda.vim',
  -- Multi-cursor (Ctrl+N)
  { src = 'https://github.com/mg979/vim-visual-multi', version = 'master' },
  -- Grammarly LSP for prose
  'https://github.com/emacs-grammarly/lsp-grammarly',
  -- F# language support
  'https://github.com/ionide/Ionide-vim',
  -- Smart comment toggling
  'https://github.com/numToStr/Comment.nvim',
})

-- autopairs
require('nvim-autopairs').setup {}

-- indent-blankline
require('ibl').setup {}

-- nvim-lint
local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint-cli2' },
}
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})

-- nvim-highlight-colors
require('nvim-highlight-colors').setup { render = 'background' }

-- auto-save
require('auto-save').setup {}

-- guess-indent
require('guess-indent').setup {}

-- todo-comments
require('todo-comments').setup { signs = false }

-- Comment.nvim
require('Comment').setup()

-- img-clip
local year = os.date '%Y'
require('img-clip').setup {
  default = {
    dir_path = '/home/titus/github/website/static/images/' .. year .. '/',
    extension = 'webp',
    process_cmd = '/usr/bin/cwebp -quiet -q 80 -o - -- - 2>/dev/null',
    template = '![$FILE_NAME_NO_EXT](/images/' .. year .. '/$FILE_NAME)',
    relative_template_path = false,
  },
  filetypes = {
    markdown = { template = '![$FILE_NAME_NO_EXT](/images/' .. year .. '/$FILE_NAME)' },
  },
}
