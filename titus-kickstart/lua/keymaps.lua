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
-- <S-h>/<S-l> are overridden by bufferline.nvim with BufferLineCyclePrev/Next
map('n', '<S-h>', ':bprevious<CR>', opts)
map('n', '<S-l>', ':bnext<CR>', opts)
map('n', '<S-q>', '<cmd>bdelete!<CR>', { silent = true, desc = 'Close buffer' })

map('n', '<Leader>1', '1gt', { silent = true, desc = 'Go to tab 1' })
map('n', '<Leader>2', '2gt', { silent = true, desc = 'Go to tab 2' })
map('n', '<Leader>3', '3gt', { silent = true, desc = 'Go to tab 3' })
map('n', '<Leader>4', '4gt', { silent = true, desc = 'Go to tab 4' })
map('n', '<Leader>5', '5gt', { silent = true, desc = 'Go to tab 5' })
map('n', '<Leader>t', '<cmd>tabnew<CR>', { silent = true, desc = 'New tab' })
map('n', '<Leader>c', '<cmd>tabclose<CR>', { silent = true, desc = 'Close tab' })

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
vim.keymap.set('n', 'yc', function()
  local buf = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  local last = vim.api.nvim_buf_line_count(buf)

  local start_fence, end_fence

  for l = cur, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(buf, l - 1, l, false)[1] or ''
    if line:match '^```' then
      start_fence = l
      break
    end
  end

  if not start_fence then
    vim.notify('No opening code fence found above cursor', vim.log.levels.WARN)
    return
  end

  for l = cur, last do
    local line = vim.api.nvim_buf_get_lines(buf, l - 1, l, false)[1] or ''
    if line:match '^```' and l > start_fence then
      end_fence = l
      break
    end
  end

  if not end_fence then
    vim.notify('No closing code fence found below cursor', vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, start_fence, end_fence - 1, false)
  local text = table.concat(lines, '\n')

  vim.fn.setreg('+', text)
  vim.fn.setreg('"', text)
  vim.notify('Code block copied to clipboard', vim.log.levels.INFO)
end, { desc = 'Yank fenced code block to clipboard' })

-- ============================================================
-- [[ Comments ]]
-- ============================================================
map('n', '<leader>/', "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
map('x', '<leader>/', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- ============================================================
-- [[ Tools & Plugins ]]
-- ============================================================
map('n', '<leader>a', ':Alpha<CR>', { silent = true, desc = 'Open [A]lpha dashboard' })
map('n', '<leader>p', '<cmd>PasteImage<CR>', { silent = true, desc = '[P]aste image from clipboard' })
map('n', '<F5>', '<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>', { silent = true, desc = 'Toggle Undotree' })
map('n', '<C-\\>', '<cmd>TZAtaraxis<CR>', { silent = true, desc = 'Toggle Zen mode' })
