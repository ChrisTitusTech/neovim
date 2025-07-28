-- https://github.com/folke/snacks.nvim
return {
  {
    -- checkhealth (snacks:) install the packages for parsing images into terminal and boom. Ur
    'folke/snacks.nvim',

    -- other plugins
    dependencies = {
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      image = { enabled = true },
      picker = { enabled = true },
    },
    keys = {
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>sf',
        function()
          Snacks.picker.smart()
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>ss',
        function()
          Snacks.picker.pickers()
        end,
        desc = '[S]earch [S]elect Snacks',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = '[S]earch current [W]ord',
        mode = { 'n', 'x' },
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.grep()
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>s.',
        function()
          Snacks.picker.recent()
        end,
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      {
        '<leader><leader>',
        function()
          Snacks.picker.buffers()
        end,
        desc = '[ ] Find existing buffers',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.lines {}
        end,
        desc = '[/] Fuzzily search in current buffer',
      },
      {
        '<leader>s/',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = '[S]earch [/] in Open Files',
      },
      -- Shortcut for searching your Neovim configuration files
      {
        '<leader>sn',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[S]earch [N]eovim files',
      },
    },
  },
}
