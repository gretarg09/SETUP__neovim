local opts = {noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap -- Shorten function name

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- MODES
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",


-- NORMAL --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts) --> c-up means hold down control and press up
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts) --> S-l means hold down shift and press l
keymap("n", "<S-h>", ":bprevious<CR>", opts)  --> S-h means hold down shift and press h

-- Move to beginning/end of line
keymap("n", "B", "^", opts)
keymap("n", "E", "$", opts)

-- Add tab intentation
keymap("n", ">", "v>", opts)
keymap("n", "<", "v<", opts)


-- INSERT --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)


-- VISUAL --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<C-j>", ":m .+1<CR>==", opts) --> A-j means hold down alt then press j
keymap("v", "<C-k>", ":m .-2<CR>==", opts) --> A-j means hold down alt then press k
--keymap("v", "p", '"_dP', opts) -- I dont use this, overwrite the yank register (min 13 in video).


-- VISUAL BLOCK --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<C-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<C-k>", ":move '<-2<CR>gv-gv", opts)


-- TERMINAL --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)


