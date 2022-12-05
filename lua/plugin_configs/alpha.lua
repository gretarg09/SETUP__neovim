local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
-- This can be generated using https://patorjk.com/software/taag/#p=display&v=0&f=ANSI%20Shadow&t=NEOVIM
dashboard.section.header.val = {
"██╗  ██╗██╗   ██╗██████╗ ██╗███████╗    ██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗    ██████╗ ███████╗███╗   ██╗ ██████╗██╗  ██╗",
"██║ ██╔╝██║   ██║██╔══██╗██║██╔════╝    ██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝    ██╔══██╗██╔════╝████╗  ██║██╔════╝██║  ██║",
"█████╔╝ ██║   ██║██████╔╝██║███████╗    ██║ █╗ ██║██║   ██║██████╔╝█████╔╝     ██████╔╝█████╗  ██╔██╗ ██║██║     ███████║",
"██╔═██╗ ██║   ██║██╔══██╗██║╚════██║    ██║███╗██║██║   ██║██╔══██╗██╔═██╗     ██╔══██╗██╔══╝  ██║╚██╗██║██║     ██╔══██║",
"██║  ██╗╚██████╔╝██║  ██║██║███████║    ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗    ██████╔╝███████╗██║ ╚████║╚██████╗██║  ██║",
"╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝     ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝"
}

-- Set menu
dashboard.section.buttons.val = {
    dashboard.button( "f", "Find file", ":Telescope find_files<CR>"),
    dashboard.button( "g", "Find word", ":Telescope live_grep<CR>"),
    dashboard.button( "r", "Recent", ":Telescope oldfiles<CR>"),
    dashboard.button( "n", "Notes", ":cd $HOME/Notes | Telescope find_files<CR>"),

    dashboard.button( "c", "Neovim configs", ":cd $HOME/.config/nvim | Telescope find_files<CR>"),
    dashboard.button( "b", "Budget Optimiser", ":cd $HOME/Precis/git_repos/ds-budget-optimiser | Telescope find_files<CR>"),
    dashboard.button( "i", "Integrated Attribution", ":cd $HOME/Precis/git_repos/precis-dev-integrated-attribution | Telescope find_files<CR>"),

    dashboard.button( "q", "Quit NVIM", ":qa<CR>"),
}

local function footer()
    local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
    local version = vim.version()
    local nvim_version_info = "  VERSION: " .. version.major .. "." .. version.minor .. "." .. version.patch

    return datetime ..  nvim_version_info
end

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "Constant"
--
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])