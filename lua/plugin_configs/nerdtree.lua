local opts = {noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap -- Shorten function name

keymap("n", "<C-n>", ":NERDTreeToggle <CR>", opts)
