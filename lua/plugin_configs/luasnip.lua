-- Load snippets from ~/.config/nvim/LuaSnip/
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})

-- Somewhere in your Neovim startup, e.g. init.lua
require("luasnip").config.set_config({ -- Setting LuaSnip config

  -- Enable autotriggered snippets
  enable_autosnippets = true,

  -- Use Tab (or some other key if you prefer) to trigger visual selection
  store_selection_keys = "<Tab>",
})


-- Remember that luasnips define a lot of mappings. You can see them with :help luasnip-basics (scroll a bit up).
-- I will list the most common ones here:
--   local ls = require("luasnip")
--   local s = ls.snippet
--   local sn = ls.snippet_node
--   local t = ls.text_node
--   local i = ls.insert_node
--   local f = ls.function_node
--   local d = ls.dynamic_node
--   local fmt = require("luasnip.extras.fmt").fmt
--   local fmta = require("luasnip.extras.fmt").fmta
--   local rep = require("luasnip.extras").rep
