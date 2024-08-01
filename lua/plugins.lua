print('Running lazy as plugin manager')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then

  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system(
      { 
          "git", 
          "clone",
          "--filter=blob:none",
          "--branch=stable",
          lazyrepo,
          lazypath
      }
  )

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo(
        {
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        },
        true,
        {}
    )
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- -- Make sure to setup `mapleader` and `maplocalleader` before
-- -- loading lazy.nvim so that mappings are correct.
-- -- This is also a good place to setup other settings (vim.opt)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",

        config = function ()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { -- auto install relevant parser while opening a file if parser is not found.
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "elixir",
                    "heex",
                    "javascript",
                    "html",
                    "rust",
                    "python"
                },
                sync_install = false,
                auto_install = true, -- auto install relevant parser while opening a file if parser is not found.
                highlight = { enable = true },
                indent = { enable = true },

                -- Incremental selection
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gis", -- Start selection.
                        node_incremental = "gni", -- Selection increment.
                        scope_incremental = "gsi", -- Selection scope.
                        node_decremental = "gnd", -- Selection decrement.
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']m'] = '@function.outer',
                            [']]'] = '@class.outer',
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            [']['] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            ['[['] = '@class.outer',
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            ['[]'] = '@class.outer',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>s'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>S'] = '@parameter.inner',
                        },
                    },
                }
            })
        end

    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects"
    },
    {
        "neovim/nvim-lspconfig",
        -- end
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {"mason.nvim"}, -- make sure that mason.nvim is setup before mason-lspconfig
        config = function()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers({
                function (server_name) -- default handler callback
                    require("lspconfig")[server_name].setup {
                        on_attach = function(_, bufnr)
                            local nmap = function (keys, func, description)
                                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. description })
                            end

                            nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                            nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                            nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                            nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
                            nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                            nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                            nmap('K', vim.lsp.buf.hover, 'Hover Documentation') -- See `:help K` for why this keymap
                            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

                            -- -- Lesser used LSP functionality
                            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')

                            nmap(
                                '<leader>wl',
                                function()
                                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                                end,
                                '[W]orkspace [L]ist Folders'
                            )

                            -- Create a command `:Format` local to the LSP buffer
                            vim.api.nvim_buf_create_user_command(
                                bufnr,
                                'Format',
                                function(_)
                                    vim.lsp.buf.format()
                                end,
                                { desc = 'Format current buffer with LSP' }
                            )

                        end
                    }
                end,
                -- see :h mason-lspconfig-automatic-server-setup for more information.
            })
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        requires = {{"nvim-lua/plenary.nvim"}},
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local actions = require("telescope.actions")
            require('telescope').setup({
                defaults = {
                    mappings = {
                         i = {
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-c>"] = actions.close,
                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,
                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                            ["<PageUp>"] = actions.results_scrolling_up,
                            ["<PageDown>"] = actions.results_scrolling_down,
                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-l>"] = actions.complete_tag,
                            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                        },
                        n = {
                            ["<esc>"] = actions.close,
                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,
                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["H"] = actions.move_to_top,
                            ["M"] = actions.move_to_middle,
                            ["L"] = actions.move_to_bottom,
                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,
                            ["gg"] = actions.move_to_top,
                            ["G"] = actions.move_to_bottom,
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                            ["<PageUp>"] = actions.results_scrolling_up,
                            ["<PageDown>"] = actions.results_scrolling_down,
                            ["?"] = actions.which_key,
                        },
                    }
                }
            })
        end
    },
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup({
                view = {
                    float = {
                        enable = true,
                        open_win_config = function()
                            -- [1st August 2024] This function was written by GaG with the help of chatgpt
                            -- I need to maintain this code myself.
                            local screen_width = vim.api.nvim_get_option("columns")
                            local screen_height = vim.api.nvim_get_option("lines")
                            local window_width = math.floor(screen_width * 0.8)
                            local window_height = math.floor(screen_height * 0.8)
                            local center_x = math.floor((screen_width - window_width) / 2)
                            local center_y = math.floor((screen_height - window_height) / 2)

                            return {
                                relative = "editor",
                                border = "rounded",
                                width = window_width,
                                height = window_height,
                                row = center_y,
                                col = center_x,
                            }
                        end,
                    },
                    width = 30, -- Default width when not using float
                },

                -- Automatically close nvim-tree when it's the last window
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
                -- Show git status icons
                git = {
                    enable = true,
                    ignore = false,
                },
                -- Enable file type icons
                renderer = {
                    icons = {
                        show = {
                            git = true,
                            folder = true,
                            file = true,
                            folder_arrow = true,
                        },
                    },
                },
            })
        end
    },
    {
        -- TODO fix the icons
        'stevearc/aerial.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("aerial").setup({
                -- optionally use on_attach to set keymaps when aerial has attached to a buffer
                on_attach = function(bufnr)
                    -- Jump forwards/backwards with '{' and '}'
                    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
                end,
            })

        end
    }
})
