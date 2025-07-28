-- https://github.com/folke/snacks.nvim
return {
  {
    -- checkhealth (snacks:) install the packages for parsing images into terminal and boom. Ur
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      image = { enabled = true },
    },
  },
}
