print('loading options')
-- :help options
-- :options

local options = {
    backup = false,                          -- creates a backup file
    clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    cmdheight = 2,                           -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 1,                        -- Needed 1 or 2 for obsidian plugin to work.
    fileencoding = "utf-8",                  -- the encoding written to a file
    encoding = "utf-8",                      -- set encoding
    hlsearch = true,                         -- highlight all matches on previous search pattern
    ignorecase = true,                       -- ignore case in search patterns
    mouse = "a",                             -- allow the mouse to be used in neovim
    pumheight = 10,                          -- pop up menu height
    showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
    showtabline = 2,                         -- always show tabs
    smartcase = true,                        -- smart case
    smartindent = true,                      -- make indenting smarter again
    splitbelow = true,                       -- force all horizontal splits to go below current window
    splitright = true,                       -- force all vertical splits to go to the right of current window
    swapfile = false,                        -- creates a swapfile
    termguicolors = true,                    -- set term gui colors (most terminals support this)
    timeoutlen = 1000,                       -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true,                         -- enable persistent undo
    updatetime = 300,                        -- faster completion (4000ms default)
    writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true,                        -- convert tabs to spaces
    cursorline = true,                       -- highlight the current line
    number = true,                           -- set numbered lines
    relativenumber = true,                   -- set relative numbered lines
    numberwidth = 4,                         -- set number column width to 2 {default 4}
    signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
    wrap = true,                             -- display lines as one long line
    scrolloff = 4,                           -- is one of my fav
    sidescrolloff = 8,
    guifont = "monospace:h17",               -- the font used in graphical neovim applications

    showmatch = true,                        -- Highlight matchin [{()}]
    incsearch = true,                        -- Search as character are entered

    tabstop = 4,                             -- Number of spaces tabs counts for.
    softtabstop = 4,
    shiftwidth = 4,

    virtualedit = "block",                    -- Allow virtual editing in visual block mode. see :help virtualedit for more info.

    inccommand = "split",                     -- split the screen and show me the changes that I am about to make in real time.
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
