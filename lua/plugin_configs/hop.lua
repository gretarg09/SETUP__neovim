local opts = {noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap -- Shorten function name


keymap('n', 's', ":HopChar2 <CR>", opts)
keymap('n', '<leader>j', ":HopLineAC <CR>", opts)
keymap('n', '<leader>k', ":HopLineBC <CR>", opts)
