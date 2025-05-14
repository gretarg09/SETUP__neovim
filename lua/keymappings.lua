print('loading keymaps')

-- ____________ HELPERS _______________
local function find_project_root()
  -- Define your root markers, e.g., .git, package.json, etc.
  local markers = {'.git', 'package.json', 'Cargo.toml', 'pyproject.toml'}

  
  -- Use the vim.loop (libuv) library to walk up the directory structure
  local path = vim.fn.expand('%:p:h')
  local root = vim.fn.getcwd()

  for _, marker in ipairs(markers) do
    if vim.fn.finddir(marker, path .. ';') ~= '' or vim.fn.findfile(marker, path .. ';') ~= '' then
      root = vim.fn.fnamemodify(vim.fn.finddir(marker, path .. ';'), ':h')
      break
    end
  end

  return root
end

print("The project root has been found to be: " .. find_project_root())


-- ____________ KEYMAPPINGS _______________
local opts = {noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.keymap.set -- Shorten function name

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

--REFRESH CONFIG
keymap("n", "<Leader><Leader>", ":source $MYVIMRC<CR>", opts)


-- TELESCOPE 
local builtin = require('telescope.builtin')
--vim.keymap.set('n', '<leader>f', builtin.find_files, {})
keymap('n', '<leader>f', builtin.git_files, {})
keymap(
    'n',
    '<leader>ff',
    function()
        builtin.find_files({
            prompt_title = "Find Files",
            file_ignore_patterns = {
                "%.log$",
                "%.tmp$"
            },
            cwd = find_project_root()
        })
    end,
    {}
)
keymap('n', '<leader>fg', builtin.live_grep, {})
keymap('n', '<leader>fb', builtin.buffers, {})
keymap('n', '<leader>fo', builtin.oldfiles, {})
keymap('n', '<leader>fm', builtin.marks, {})
keymap('n', '<leader>fh', builtin.help_tags, {})

-- AERIAL
keymap("n", "<leader>a", "<cmd>AerialToggle!<CR>", opts)


-- NVIMTREE 
keymap("n", "<C-n>", ":NvimTreeToggle<CR>", opts)

-- DAP
keymap("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
keymap("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
keymap("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
keymap("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
keymap("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })

keymap(
  "n",
  "<Leader>dd",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Debugger set conditional breakpoint" }
)

keymap("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
keymap("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
keymap("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- IMG CLIP
keymap("n", "<leader>p", "<cmd>PasteImage<cr>", { desc = "Paste image from system clipboard" })
