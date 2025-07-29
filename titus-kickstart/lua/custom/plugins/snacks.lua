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
      dashboard = {
        enabled = true,
        position = 'center',
        width = 40,
        height = 50,
        border = 'rounded',
        theme = 'dark',
        preset = {
          header = [[
████████╗██╗████████╗██╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗
╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝██║   ██║██║████╗ ████║
   ██║   ██║   ██║   ██║   ██║███████╗██║   ██║██║██╔████╔██║
   ██║   ██║   ██║   ██║   ██║╚════██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║   ██║   ██║   ╚██████╔╝███████║ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
        },
        sections = {
          { section = 'keys', padding = 1 },
          { pane = 1, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
          { pane = 1, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
          {
            pane = 1,
            icon = ' ',
            desc = 'Browse Repo',
            padding = 1,
            key = 'b',
            action = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                title = 'Open Issues',
                cmd = 'gh issue list -L 3',
                key = 'i',
                action = function()
                  vim.fn.jobstart('gh issue list --web', { detach = true })
                end,
                icon = ' ',
                height = 7,
              },
              {
                icon = ' ',
                title = 'Open PRs',
                cmd = 'gh pr list -L 3',
                key = 'P',
                action = function()
                  vim.fn.jobstart('gh pr list --web', { detach = true })
                end,
                height = 7,
              },
              {
                icon = ' ',
                title = 'Git Status',
                cmd = 'git --no-pager diff --stat -B -M -C',
                height = 10,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend('force', {
                pane = 2,
                section = 'terminal',
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
          { section = 'startup' },
        },
      },
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
        '<leader>ff',
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
        '<leader>fg',
        function()
          Snacks.picker.grep()
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>fp',
        function()
          Snacks.picker.projects()
        end,
        desc = '[S]earch [P]rojects',
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
