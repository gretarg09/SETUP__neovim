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
    -- CATPPUCCIN
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end
    },
    -- NVIM TREESITTER
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
                    "python",
                    "markdown",
                    "markdown_inline",
                    "latex",
                    "bibtex"
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
    -- NVIM TREESITTER TEXTOBJECTS
    {
        "nvim-treesitter/nvim-treesitter-textobjects"
    },
    -- NVIM LSP CONFIG
    {
        "neovim/nvim-lspconfig",
        -- end
    },
    -- MASON
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    -- MASON LSP CONFIG
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
    -- TELESCOPE
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
    -- NVIM TREE
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
    -- AREAL
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
                    vim.keymap.set("n", "(", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                    vim.keymap.set("n", ")", "<cmd>AerialNext<CR>", { buffer = bufnr })
                end,
            })

        end
    },
   -- HOP
    {
        'smoka7/hop.nvim',
        version = "*",
        opts = {
            keys = 'etovxqpdygfblzhckisuran'
        },
        config = function()
            require('hop').setup()
            vim.keymap.set('n', 's', ":HopPattern<CR>", { noremap = true, silent = true })
            vim.keymap.set('n', 't', ":HopNode<CR>", { noremap = true, silent = true })
        end
    },
   -- NVIM CMP
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        },

        config = function()

            local cmp = require 'cmp'
            local luasnip = require 'luasnip'

            local kind_icons = {
                Text = "",
                Method = "m",
                Function = "",
                Constructor = "",
                Field = "",
                Variable = "",
                Class = "",
                Interface = "",
                Module = "",
                Property = "",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
            }

            cmp.setup {
                  snippet = {
                    expand = function(args)
                      luasnip.lsp_expand(args.body)
                    end,
                  },

                  mapping = cmp.mapping.preset.insert {
                        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-f>'] = cmp.mapping.scroll_docs(4),
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<CR>'] = cmp.mapping.confirm {
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = true,
                        },
                        ['<Tab>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            elseif
                                luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                            else
                                fallback()
                            end
                        end, { 'i', 's' }),
                        ['<S-Tab>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            elseif
                                luasnip.jumpable(-1)
                            then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end, { 'i', 's' }),
                  },

                  formatting = {
                        fields = { "kind", "abbr", "menu" },
                        format = function(entry, vim_item)
                            -- Kind icons
                            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

                            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                            vim_item.menu = ({
                                luasnip = "[Snippet]",
                                nvim_lsp = "[LSP]",
                                nvim_lua = "[NVIM_LUA]",
                                buffer = "[Buffer]",
                                path = "[Path]",
                            })[entry.source.name]

                            return vim_item
                        end,
                  },

                  sources = {
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "buffer" },
                    { name = "path" },
                },
            }
        end
    },
    -- AVANTE
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        opts = {
            -- add any opts here
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            -- "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
    -- VIMTEX
    {
        "lervag/vimtex",
        lazy = false,     -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
                vim.g.vimtex_view_method = "zathura"
         end
    },
    -- NVIM DAP
    {
        "mfussenegger/nvim-dap",
        config = function ()
            require("dapui").setup()

            local dap, dapui = require("dap"), require("dapui")

            dap.listeners.before.attach.dapui_config = function()
              dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
              dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
              dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
              dapui.close()
            end
        end
    },
    -- NVIM DAP UI
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
    },
    -- RUSTACEANVIM
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false, -- This plugin is already lazy
        config = function()
            -- This part of the code is taken from the following video: https://www.youtube.com/watch?v=E2mKJ73M9pg
            local mason_registry = require('mason-registry')
            local codelldb = mason_registry.get_package("codelldb")

            local extension_path = codelldb:get_install_path() .. "/extension/"
            print('the extension path registry')
            print(extension_path)

            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

            local cfg = require('rustaceanvim.config')

            vim.g.rustaceanvim = {
                dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
            }
        end
    },
    -- RENDER MARKDOWN 
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        config = function ()
            require('render-markdown').setup({

                completions = { lsp = { enabled = true } },

                checkbox = {
                    unchecked = { icon = '✘ ' },
                    checked = { icon = '✔ ' },
                    custom = { todo = { rendered = '◯ ' } },
                },
            })
        end
    },
    -- OBSIDIAN
    {
        'obsidian-nvim/obsidian.nvim',
        dependencies = {"hrsh7th/nvim-cmp", "nvim-telescope/telescope.nvim"},
        config = function ()
            require('obsidian').setup({
                workspaces = {
                    {
                        name = "kuris_second_brain",
                        path = "~/Dropbox/kuris_second_brain",
                    },
                },
                ui = {
                    enable = false
                },
                mappings = {
                    -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
                    ["gf"] = {
                      action = function()
                        return require("obsidian").util.gf_passthrough()
                      end,
                      opts = { noremap = false, expr = true, buffer = true },
                    },
                    -- Toggle check-boxes.
                    ["<leader>ch"] = {
                      action = function()
                        return require("obsidian").util.toggle_checkbox()
                      end,
                      opts = { buffer = true },
                    },
                    -- Smart action depending on context, either follow link or toggle checkbox.
                    ["<leader><cr>"] = {
                      action = function()
                        return require("obsidian").util.smart_action()
                      end,
                      opts = { buffer = true, expr = true },
                    }
                },
                picker = {
                    name = "telescope.nvim", -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
                    note_mappings = {
                      new = "<C-x>", -- Create a new note from your query.
                      insert_link = "<C-l>", -- Insert a link to the selected note.
                    },
                    tag_mappings = {
                      tag_note = "<C-x>", -- Add tag(s) to current note.
                      insert_tag = "<C-l>", -- Insert a tag at the current location.
                    },
                },
            })
        end
    },
    -- IMAGE
    {
        "3rd/image.nvim",
        event = "VeryLazy",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter",
                build = ":TSUpdate",
                config = function()
                    require("nvim-treesitter.configs").setup({
                        ensure_installed = { "markdown" },
                        highlight = { enable = true },
                  })
                end,
          },
        },
        opts = {
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = true,
                    floating_windows = false,
                    filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
                },
            },
            max_width = nil,
            max_height = nil,
            max_width_window_percentage = nil,
            max_height_window_percentage = 50,
            kitty_method = "normal",
        },
    },
    -- LUASNIP
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = function ()
            require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})
            require("luasnip").config.set_config({ -- Setting LuaSnip config
              enable_autosnippets = true,
              store_selection_keys = "<Tab>", -- Use Tab to trigger visual selection
            })
        end
    }
})

