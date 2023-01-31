local configs = require("nvim-treesitter.configs")

configs.setup {
  ensure_installed = "all", -- one or "all" or a list of language
  sync_install = false,
  ignore_install = { "" }, -- List of parsers to ignore installing
  auto_install = true,

  highlight = {
    enable = true, -- false will disable the whole extension
    --disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },

  --indent = { enable = true, disable = { "yaml" } },
  --rainbow = {enable = true}
}
