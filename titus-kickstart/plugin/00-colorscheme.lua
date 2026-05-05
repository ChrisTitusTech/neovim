-- Colorscheme: loaded first (00- prefix) to avoid flash of default colors.
vim.pack.add {
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/lunarvim/synthwave84.nvim', -- alternate colorscheme
}

require('kanagawa').setup {
  overrides = function(colors)
    local theme = colors.theme
    return {
      -- Floats
      NormalFloat = { fg = theme.ui.fg, bg = theme.ui.bg_m3 },
      FloatBorder = { fg = theme.ui.special, bg = theme.ui.bg_m3 },
      FloatTitle = { fg = theme.ui.special, bg = theme.ui.bg_m3, bold = true },

      -- Syntax: less blanket bold, more hierarchy
      ['@keyword'] = { fg = theme.syn.keyword, bold = true },
      ['@type.builtin'] = { fg = theme.syn.type },
      ['@function'] = { fg = theme.syn.fun, bold = true },
      ['@constructor'] = { fg = theme.syn.fun },
      ['@string'] = { fg = theme.syn.string },
      Comment = { fg = theme.syn.comment, italic = true },
      ['@constant'] = { fg = theme.syn.constant },
      ['@number'] = { fg = theme.syn.number },

      -- Popup menu
      Pmenu = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
      PmenuSel = { fg = theme.ui.fg, bg = theme.ui.bg_p2, bold = true },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.special },

      -- Telescope
      TelescopeTitle = { fg = theme.ui.special, bold = true },
      TelescopePromptNormal = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
      TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
      TelescopePreviewNormal = { fg = theme.ui.fg, bg = theme.ui.bg_dim },
      TelescopeBorderNormal = { fg = theme.ui.special, bg = theme.ui.bg_m1 },

      -- Extra pop
      Visual = { bg = theme.ui.bg_p2 },
      Search = { fg = theme.ui.bg, bg = theme.syn.fun, bold = true },
      IncSearch = { fg = theme.ui.bg, bg = theme.syn.keyword, bold = true },
      CursorLine = { bg = theme.ui.bg_m1 },
      WinSeparator = { fg = theme.ui.special },
    }
  end,
}
require('kanagawa').load 'wave'
