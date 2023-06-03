-- This requires the ~/.virtualenvs folder to exist and contain a virtual environment where the debugpy has been installed
--  For more information see: https://github.com/mfussenegger/nvim-dap-python
--  dab = debugger adapter protocol
--  I watched the following video to set this up :  https://www.youtube.com/watch?v=0moS8UHupGc&t=2054s


-- Importing
local status_ok, dap_python = pcall(require, 'dap-python')
if not status_ok then
    vim.notify(status_ok)
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  return
end

local dap_virtual_text_status_ok, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not dap_virtual_text_status_ok then
  return
end

local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  return
end


dap_python.setup('~/.virtualenvs/debugpy/bin/python')
dap_python.test_runner = 'pytest'
dap_virtual_text.setup()


local opts = {noremap = true, silent = true }

vim.keymap.set("n", "<F1>", ":lua require'dap'.step_over()<CR>", opts)
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<CR>", opts)
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_out()<CR>", opts)
vim.keymap.set("n", "<F4>", ":lua require'dap'.continue()<CR>", opts)
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.keymap.set("n", "<Leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
vim.keymap.set("n", "<Leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)

--vim.keymap.set("n", "<Leader>dr", ":lua require'dap'.repl.open()<CR>", opts) -- NOTE do I need this?
--vim.keymap.set("n", "<Leader>dl", ":lua require'dap'.run_last()<CR>", opts) -- Note do I need this?-

--vim.keymap.set("n", "<Leader>ds", ":lua require('dap-python').test_method()<CR>", opts)
vim.keymap.set("n", "<Leader>dds", ":lua require('dap').continue()<CR>", opts) -- running a main function in python
vim.keymap.set("n", "<Leader>ddt", ":lua require('dapui').toggle()<CR>", opts)
vim.keymap.set("n", "<Leader>ddo", ":lua require('dapui').open()<CR>", opts)
vim.keymap.set("n", "<Leader>ddc", ":lua require('dapui').close()<CR>", opts)

vim.notify("dap loaded with python main execution activated")


-- Setup the listeners for dap ui, see readme file of the project for more info
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

--dap.listeners.before.event_terminated["dapui_config"] = function()
--  dapui.close()
--end

--dap.listeners.before.event_exited["dapui_config"] = function()
--  dapui.close()
--end


dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      -- Elements can be strings or table with id and size keys.
      elements = {{id = "scopes", size = 0.25 },
                   "breakpoints",
                   "stacks",
                   "watches"},
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})
