print('Setting up folding')

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""

-- The ability to open and closing nearest fold with enter
vim.api.nvim_set_keymap("n", "<CR>", "za", { noremap = true, silent = true })
