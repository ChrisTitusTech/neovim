-- Snacks: loaded early (01- prefix) so its picker is available to other plugins.
vim.pack.add({
  { src = 'https://github.com/nvim-tree/nvim-web-devicons', version = 'master' },
  'https://github.com/folke/snacks.nvim',
})

---@type snacks.Config
require('snacks').setup {
  explorer = { enabled = true },
  picker = { enabled = true },
  project = {
    dirs = {
      '~/github',
      '~/projects',
      '~/build',
    },
  },
  indent = { enabled = true },
  notifier = { enabled = true },
  statuscolumn = { enabled = true },
  zen = { enabled = true },
}

local map = vim.keymap.set
map('n', '<leader>sh', function() Snacks.picker.help() end, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sc', function() Snacks.picker.commands() end, { desc = '[S]earch [C]ommands' })
map('n', '<leader>sb', function() Snacks.picker.builtin() end, { desc = '[S]earch [B]uiltins' })
map('n', '<leader>sf', function() Snacks.picker.files() end, { desc = '[S]earch [F]iles' })
map('n', '<leader>fe', function() Snacks.explorer.open() end, { desc = '[F]iles [E]xplorer open tree' })
map('n', '<leader>ff', function() Snacks.picker.smart() end, { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', function() Snacks.picker.pickers() end, { desc = '[S]earch [S]elect Snacks' })
map('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord', mode = { 'n', 'x' } })
map('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })
map('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = '[S]earch [P]rojects' })
map('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', function() Snacks.picker.recent() end, { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader><leader>', function() Snacks.picker.buffers() end, { desc = '[ ] Find existing buffers' })
map('n', '<leader>/', function() Snacks.picker.lines {} end, { desc = '[/] Fuzzily search in current buffer' })
map('n', '<leader>s/', function() Snacks.picker.grep_buffers() end, { desc = '[S]earch [/] in Open Files' })
map('n', '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
