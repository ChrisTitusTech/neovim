local autocmd = vim.api.nvim_create_autocmd
-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.undodir = vim.fn.expand('~/.vim/undodir')
vim.opt.undofile = true
vim.wo.relativenumber = true

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- Colorscheme
---
vim.opt.termguicolors = true
vim.cmd('colorscheme onedark')

---
-- Titus Custom Markdown HUGO Image Insert
---
require'clipboard-image'.setup {
  markdown = {
   img_dir = {"content/images", "%:p:h:t", "%:t:r"},
   img_dir_txt = {"/images", "%:p:h:t", "%:t:r"},
   img_name = function ()
      vim.fn.inputsave()
      local name = vim.fn.input('Name: ')
      vim.fn.inputrestore()

      if name == nil or name == '' then
        return os.date('%y-%m-%d-%H-%M-%S')
      end
      return name
    end,
    img_handler = function ()
        return function (path)
            return os.execute(string.format('~/.scripts/tinypng -s -f %s &', path))
        end
    end
  }
}

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.completion.spell,
    },
})

require('mason-tool-installer').setup {

  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {

    -- you can pin a tool to a particular version
    --{ 'golangci-lint', version = 'v1.47.0' },

    -- you can turn off/on auto_update per tool
    --{ 'bash-language-server', auto_update = true },

    'awk-language-server',
    'bash-debug-adapter',
    'bash-language-server',
    'cmake-language-server',
    'cmakelang',
    'codespell',
    'cpptools',
    'cspell',
    'grammarly-languageserver',
    'lua-language-server',
    'luacheck',
    'luaformatter',
    'markdownlint',
    'marksman',
    'misspell',
    'powershell-editor-services',
    'prettier',
    'prettierd',
    'shellcheck',
    'textlint',
    'vim-language-server',
    'write-good',
    'stylua',
    'shellcheck',
    'editorconfig-checker',
    'impl',
    'json-to-struct',
    'revive',
    'shfmt',
    'staticcheck',
    'vint',
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = true,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = true,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  start_delay = 3000, -- 3 second delay
}
