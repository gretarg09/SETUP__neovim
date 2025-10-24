print('Setting up folding')

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.opt_local.foldmethod = "expr"
--     vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
--   end,
-- })

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""

-- see keymappings smart enter functionality for mappings to fold.
