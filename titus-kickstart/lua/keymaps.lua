local map = vim.keymap.set
local opts = { silent = true }

-- ============================================================
-- [[ Window Navigation & Resize ]]
-- ============================================================
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
map('n', '<C-Up>',    ':resize -2<CR>',          opts)
map('n', '<C-Down>',  ':resize +2<CR>',          opts)
map('n', '<C-Left>',  ':vertical resize -2<CR>', opts)
map('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- ============================================================
-- [[ Buffer & Tab Navigation ]]
-- ============================================================
-- <S-h>/<S-l> are overridden by bufferline.nvim with BufferLineCyclePrev/Next
map('n', '<S-h>', ':bprevious<CR>', opts)
map('n', '<S-l>', ':bnext<CR>',     opts)
map('n', '<S-q>', '<cmd>bdelete!<CR>', { silent = true, desc = 'Close buffer' })

map('n', '<Leader>1', '1gt', { silent = true, desc = 'Go to tab 1' })
map('n', '<Leader>2', '2gt', { silent = true, desc = 'Go to tab 2' })
map('n', '<Leader>3', '3gt', { silent = true, desc = 'Go to tab 3' })
map('n', '<Leader>4', '4gt', { silent = true, desc = 'Go to tab 4' })
map('n', '<Leader>5', '5gt', { silent = true, desc = 'Go to tab 5' })
map('n', '<Leader>t', '<cmd>tabnew<CR>',   { silent = true, desc = 'New tab' })
map('n', '<Leader>c', '<cmd>tabclose<CR>', { silent = true, desc = 'Close tab' })

-- ============================================================
-- [[ Search ]]
-- ============================================================
map('n', '<Esc>',      '<cmd>nohlsearch<CR>',  { desc = 'Clear search highlights' })
map('n', '<leader>nh', '<cmd>nohlsearch<CR>',  { desc = '[N]o [H]ighlight — clear search' })

-- ============================================================
-- [[ Diagnostics ]]
-- ============================================================
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- ============================================================
-- [[ Terminal ]]
-- ============================================================
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ============================================================
-- [[ Editing ]]
-- ============================================================
map('i', 'jj', '<ESC>',   { silent = true, desc = 'Exit insert mode' })
map('v', 'p',  '"_dP',    { silent = true, desc = 'Paste without overwriting clipboard' })
map('v', '<',  '<gv',     { silent = true, desc = 'Dedent and stay in visual mode' })
map('v', '>',  '>gv',     { silent = true, desc = 'Indent and stay in visual mode' })
map('n', '<leader>e', '$', { silent = true, desc = 'Jump to [E]nd of line' })
map('n', 'S', ':%s//g<Left><Left>', { desc = 'Search and replace in buffer' })

-- ============================================================
-- [[ Comments ]]
-- ============================================================
map('n', '<leader>/', "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
map('x', '<leader>/', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- ============================================================
-- [[ Tools & Plugins ]]
-- ============================================================
map('n', '<leader>a',  ':Alpha<CR>',                                    { silent = true, desc = 'Open [A]lpha dashboard' })
map('n', '<leader>p',  '<cmd>PasteImage<CR>',                           { silent = true, desc = '[P]aste image from clipboard' })
map('n', '<F5>',       '<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>', { silent = true, desc = 'Toggle Undotree' })
map('n', '<C-\\>',   '<cmd>TZAtaraxis<CR>',                           { silent = true, desc = 'Toggle Zen mode' })
