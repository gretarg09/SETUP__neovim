-- References
-- https://alpha2phi.medium.com/neovim-for-beginners-lsp-using-null-ls-nvim-bd954bf86b40
-- https://smarttech101.com/nvim-lsp-set-up-null-ls-for-beginners/
--
--# Cheetsheat
-- :NullLsInfo
--
--# NOTE
-- I need to install black, isort and pylint for the following to work.
--      pip install black
--      pip install isort
--      pip install pylint
--
null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.pylint.with({
          diagnostics_postprocess = function(diagnostic)
            diagnostic.code = diagnostic.message_id
          end,
        }),

        null_ls.builtins.formatting.black.with{extra_args={ "--fast" }},
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.prettier,

        null_ls.builtins.diagnostics.sqlfluff.with({
            extra_args = { "--dialect", "bigquery" }, -- change to your dialect
        }),
    }
})

--# Keybindings
vim.cmd('map <Leader>lf :lua vim.lsp.buf.formatting_sync(nil, 10000)<CR>')
vim.cmd('map <Leader>lF :lua vim.lsp.buf.range_formatting()<CR>')

-- Note 1: Please note that the formatting command is a little different in nvim v 0.8:
-- 0.7
-- vim.lsp.buf.formatting_sync(nil, 2000) -- 2 seconds
-- 0.8
-- vim.lsp.buf.format({ timeout_ms = 2000 }) -- 2 seconds
