require'clipboard-image'.setup {
  -- Default configuration for all typefile
  default = {
    img_dir = "img",
    img_dir_txt = "img",
    img_name = function () return os.date('%Y-%m-%d-%H-%M-%S') end,
    affix = "![](https://s3.codiy.net/%s)",
    img_handler = function ()
        return function (path)
            return os.execute(string.format('~/.scripts/tinypng.sh -s -f %s &', path))
        end
    end
  },
  -- You can create configuration for ceartain filetype by creating another field (markdown, in this case)
  -- If you're uncertain what to name your field to, you can run `:set filetype?`
  -- Missing options from `markdown` field will be replaced by options from `default` field
  markdown = {
    img_dir = "img",
    img_dir_txt = "img",
    affix = "![](https://s3.codiy.net/%s)"
  }
}
