-- see :help luasnip for more information

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key


return {
    s({trig="link", dscr="Markdown link"},
      fmt( -- The snippet code actually looks like the equation environment it produces.
        [[
             [<>](<>)
        ]],
        -- The insert node is placed in the <> angle brackets
        { i(1, "LiNk"), i(2, "DeScRiPtIoN") },
        -- This is where I specify that angle brackets are used as node positions.
        { delimiters = "<>" }
      )
    ),

    s({trig="code", dscr="Code block in markdown"},
      fmt( -- The snippet code actually looks like the equation environment it produces.
        [[
            ```<>```
        ]],
        -- The insert node is placed in the <> angle brackets
        { i(1, 'CoDe') },
        -- This is where I specify that angle brackets are used as node positions.
        { delimiters = "<>" }
      )
    ),

}
