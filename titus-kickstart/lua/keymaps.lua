local map = vim.keymap.set
local opts = { silent = true }

local function url_in_line_at_col(line, col)
  if not line or line == '' or not col or col < 1 then
    return nil
  end

  local from = 1
  while true do
    local s, e = line:find('https?://%S+', from)
    if not s then
      return nil
    end

    if col >= s and col <= e then
      local url = line:sub(s, e)
      -- Trim punctuation that commonly trails URLs in prose/markdown.
      url = url:gsub('[%]%)%}%.,;:!%?"' .. "'" .. ']+$', '')
      return url ~= '' and url or nil
    end

    from = e + 1
  end
end

-- ============================================================
-- [[ Window Navigation & Resize ]]
-- ============================================================
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
map('n', '<C-Up>', ':resize -2<CR>', opts)
map('n', '<C-Down>', ':resize +2<CR>', opts)
map('n', '<C-Left>', ':vertical resize -2<CR>', opts)
map('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- ============================================================
-- [[ Buffer & Tab Navigation ]]
-- ============================================================
-- Buffer navigation keys are owned by bufferline.nvim in plugin specs.
map('n', '<S-q>', '<cmd>bdelete!<CR>', { silent = true, desc = 'Close buffer' })

map('n', '<Leader>1', '1gt', { silent = true, desc = 'Go to tab 1' })
map('n', '<Leader>2', '2gt', { silent = true, desc = 'Go to tab 2' })
map('n', '<Leader>3', '3gt', { silent = true, desc = 'Go to tab 3' })
map('n', '<Leader>4', '4gt', { silent = true, desc = 'Go to tab 4' })
map('n', '<Leader>5', '5gt', { silent = true, desc = 'Go to tab 5' })
map('n', '<Leader>t', '<cmd>tabnew<CR>', { silent = true, desc = 'New tab' })
map('n', '<A-q>', '<cmd>tabclose<CR>', { silent = true, desc = 'Close tab' })

-- ============================================================
-- [[ Search ]]
-- ============================================================
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })
map('n', '<leader>nh', '<cmd>nohlsearch<CR>', { desc = '[N]o [H]ighlight — clear search' })
map('n', '<LeftMouse>', function()
  local m = vim.fn.getmousepos()
  if m.winid and m.winid ~= 0 and m.line and m.column and m.line > 0 and m.column > 0 then
    local ok_buf, bufnr = pcall(vim.api.nvim_win_get_buf, m.winid)
    if ok_buf and bufnr then
      local ok_line, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, m.line - 1, m.line, false)
      if ok_line then
        local target = url_in_line_at_col(lines[1] or '', m.column)
        if target then
          vim.ui.open(target)
          return
        end
      end
    end
  end

  -- Non-URL clicks should behave exactly like default Neovim mouse clicks.
  vim.api.nvim_feedkeys(vim.keycode '<LeftMouse>', 'n', false)
end, { desc = 'Click URL to open in browser' })

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
map('i', 'jj', '<ESC>', { silent = true, desc = 'Exit insert mode' })
map('v', 'p', '"_dP', { silent = true, desc = 'Paste without overwriting clipboard' })
map('v', '<', '<gv', { silent = true, desc = 'Dedent and stay in visual mode' })
map('v', '>', '>gv', { silent = true, desc = 'Indent and stay in visual mode' })
map('n', '<leader>e', '$', { silent = true, desc = 'Jump to [E]nd of line' })
map('n', 'S', ':%s//g<Left><Left>', { desc = 'Search and replace in buffer' })
map('n', '<leader>y', function()
  -- Walk up the treesitter tree to find a fenced_code_block node.
  -- The markdown parser is bundled with Neovim 0.10+, no plugin required.
  local node = vim.treesitter.get_node()
  while node and node:type() ~= 'fenced_code_block' do
    node = node:parent()
  end
  if not node then
    vim.notify('Not inside a fenced code block', vim.log.levels.WARN)
    return
  end
  -- The grammar puts the actual code lines in a code_fence_content child.
  for child in node:iter_children() do
    if child:type() == 'code_fence_content' then
      local text = vim.treesitter.get_node_text(child, 0)
      vim.fn.setreg('+', text)
      vim.fn.setreg('"', text)
      vim.notify('Code block copied to clipboard', vim.log.levels.INFO)
      return
    end
  end
  vim.notify('Code block is empty', vim.log.levels.WARN)
end, { desc = '[Y]ank fenced code block to clipboard' })

-- ============================================================
-- [[ Comments ]] (prefer <leader>/ over builtin gc/gcc)
-- ============================================================
do
  local n_gc = vim.fn.maparg('gc', 'n', false, true)
  local n_gcc = vim.fn.maparg('gcc', 'n', false, true)
  local x_gc = vim.fn.maparg('gc', 'x', false, true)

  if type(n_gcc) == 'table' and n_gcc.callback then
    map('n', '<leader>/', n_gcc.callback, { desc = 'Toggle comment line' })
  elseif type(n_gc) == 'table' and n_gc.callback then
    map('n', '<leader>/', n_gc.callback, { desc = 'Toggle comment' })
  end

  if type(x_gc) == 'table' and x_gc.callback then
    map('x', '<leader>/', x_gc.callback, { desc = 'Toggle comment selection' })
  end

  pcall(vim.keymap.del, 'n', 'gc')
  pcall(vim.keymap.del, 'n', 'gcc')
  pcall(vim.keymap.del, 'x', 'gc')
end

-- ============================================================
-- [[ Tools & Plugins ]]
-- ============================================================
map('n', '<leader>a', ':Alpha<CR>', { silent = true, desc = 'Open [A]lpha dashboard' })
map('n', '<leader>p', '<cmd>PasteImage<CR>', { silent = true, desc = '[P]aste image from clipboard' })
map('n', '<F5>', '<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>', { silent = true, desc = 'Toggle Undotree' })
map('n', '<C-\\>', '<cmd>TZAtaraxis<CR>', { silent = true, desc = 'Toggle Zen mode' })
