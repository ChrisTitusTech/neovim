-- Colorscheme: loaded first (00- prefix) to avoid flash of default colors.
vim.pack.add({
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/lunarvim/synthwave84.nvim', -- alternate colorscheme
})

require('kanagawa').setup {
  overrides = function(colors)
    local theme = colors.theme
    return {
      -- Make floating windows stand out
      NormalFloat = { bg = theme.ui.bg_dim },
      FloatBorder = { fg = theme.ui.special, bg = theme.ui.bg_dim },
      FloatTitle = { fg = theme.ui.special, bold = true },

      -- Bolder keywords and types
      ['@keyword'] = { fg = theme.syn.keyword, bold = true },
      ['@type.builtin'] = { fg = theme.syn.type, bold = true },
      ['@function'] = { fg = theme.syn.fun, bold = true },
      ['@constructor'] = { fg = theme.syn.fun },

      -- Make strings and comments more distinct
      ['@string'] = { fg = theme.syn.string, italic = true },
      Comment = { fg = theme.syn.comment, italic = true },

      -- Brighten constants and numbers
      ['@constant'] = { fg = theme.syn.constant, bold = true },
      ['@number'] = { fg = theme.syn.number, bold = true },

      -- Popup menu
      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
      PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.special },

      -- Make telescope pop
      TelescopeTitle = { fg = theme.ui.special, bold = true },
      TelescopePromptNormal = { bg = theme.ui.bg_p1 },
      TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
      TelescopePreviewNormal = { bg = theme.ui.bg_dim },
      TelescopeBorderNormal = { fg = theme.ui.bg_p2, bg = theme.ui.bg_m1 },
    }
  end,
}
require('kanagawa').load 'wave'
