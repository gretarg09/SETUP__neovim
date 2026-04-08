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
                "bibtex",
                "typst",
                "svelte",
                "javascript",
                "typescript",
                "html",
                "css",
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
    dependencies = {"williamboman/mason.nvim"}, -- make sure that mason.nvim is setup before mason-lspconfig
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
                "ruff",
                "svelte",
                "tinymist",
                "cssls",
                "html",
                "jsonls",
                "eslint",
                "tailwindcss",
            },
            automatic_installation = false,
        })

        -- Configure servers directly
        require("lspconfig").lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                        enable = true,
                    },
                    workspace = {
                        checkThirdParty = false,
                    },
                    hint = {
                        enable = true,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })

        require("lspconfig").pyright.setup({
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = "basic",
                        disableOrganizeImports = true,  -- Let Ruff handle import organization
                    }
                }
            }
        })

        require("lspconfig").ruff.setup({
            init_options = {
                settings = {
                    args = {},
                }
            }
        })

        require("lspconfig").svelte.setup({})

        require("lspconfig").cssls.setup({})

        require("lspconfig").html.setup({})

        require("lspconfig").jsonls.setup({})

        require("lspconfig").eslint.setup({
            on_attach = function(_, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    command = "EslintFixAll",
                })
            end,
        })

        require("lspconfig").tailwindcss.setup({})

        require("lspconfig").tinymist.setup({
            settings = {
                exportPdf = "onSave",
            }
        })

        -- Set up LspAttach autocmd for keybindings
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(ev)
                print("LSP attached to buffer " .. ev.buf)
                local bufnr = ev.buf
                local nmap = function (keys, func, description)
                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. description })
                end

                nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

                nmap('gl', require('telescope.builtin').diagnostics, 'Show diagnostic in telescope')

                nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

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

                vim.api.nvim_buf_create_user_command(
                    bufnr,
                    'Format',
                    function(_)
                        vim.lsp.buf.format()
                    end,
                    { desc = 'Format current buffer with LSP' }
                )
            end,
        })
    end
},
-- TELESCOPE
{
    "nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/plenary.nvim"}},
    dependencies = {
        'nvim-lua/plenary.nvim',
        "nvim-telescope/telescope-dap.nvim"
    },
    config = function()
        local telescope = require('telescope')
        local actions = require("telescope.actions")

        telescope.setup({
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

        telescope.load_extension("dap")
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
        -- "HakonHarnes/img-clip.nvim", -- [GAG]: I am already installing this plugin
        -- "zbirenbaum/copilot.lua", -- for providers='copilot'
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
-- TYPST PREVIEW
{
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '1.*',
    build = function() require('typst-preview').update() end,
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
    dependencies = {
        "jbyuki/one-small-step-for-vimkind" -- for lua debugging
    },
    config = function ()
        require("dapui").setup()

        local dap, dapui = require("dap"), require("dapui")

        -- Set up breakpoint signs with red circle
        vim.fn.sign_define('DapBreakpoint', { text='●', texthl='DapBreakpoint', linehl='', numhl=''})
        vim.fn.sign_define('DapBreakpointCondition', { text='◆', texthl='DapBreakpointCondition', linehl='', numhl=''})
        vim.fn.sign_define('DapBreakpointRejected', { text='○', texthl='DapBreakpointRejected', linehl='', numhl=''})
        vim.fn.sign_define('DapStopped', { text='→', texthl='DapStopped', linehl='DapStoppedLine', numhl=''})

        -- Set up highlight colors for breakpoint signs
        vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
        vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#ffcc00' })
        vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#888888' })
        vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#00ff00' })
        vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2a2a2a' })

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

        -- Fix "Terminal already connected to buffer N" error on second debug session.
        -- nvim-dap pools terminal buffers for reuse, but nvim_open_term can't be
        -- called twice on the same buffer. Deleting them forces fresh buffers next time.
        local function close_dap_terminals()
          vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(buf) then
                local name = vim.api.nvim_buf_get_name(buf)
                if name:match('%[dap%-terminal%]') then
                  pcall(vim.api.nvim_buf_delete, buf, { force = true })
                end
              end
            end
          end)
        end
        dap.listeners.after.event_terminated.close_dap_terminals = close_dap_terminals
        dap.listeners.after.event_exited.close_dap_terminals = close_dap_terminals

        -- VISIDATA
        dap.defaults.fallback.external_terminal = { -- GAG: Needed for the visidata logic to work.
            command = "alacritty",
            args = { "--hold", "--command" },
        }

        -- LUA DEBUGGING --> from one-small-step-for-vimkind
        dap.configurations.lua = {
            {
                type = 'nlua',
                request = 'attach',
                name = "Attach to running Neovim instance",
            }
        }

        -- From one-small-step-for-vimkind
        dap.adapters.nlua = function(callback, config)
            callback(
                {
                    type = 'server',
                    host = config.host or "127.0.0.1",
                    port = config.port or 8086
                }
            )
        end

        -- JAVASCRIPT / SVELTEKIT SERVER-SIDE DEBUGGING
        local ok, mason_registry = pcall(require, "mason-registry")
        if ok and mason_registry.is_installed("js-debug-adapter") then
            local js_debug_path = mason_registry.get_package("js-debug-adapter"):get_install_path()

            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
                },
            }

            dap.configurations.javascript = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch SvelteKit (Vite)",
                    runtimeExecutable = "pnpm",
                    runtimeArgs = { "dev" },
                    rootPath = "${workspaceFolder}",
                    cwd = "${workspaceFolder}",
                    sourceMaps = true,
                    skipFiles = { "<node_internals>/**" },
                },
            }
        end

    end
},
-- NVIM DAP UI
{
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
},
-- NVIM DAP PYTHON
{
  "mfussenegger/nvim-dap-python",
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
      require("dap-python").setup("/home/kuri/.virtualenvs/debugpy/bin/python")
      local dap = require("dap")
      table.insert(dap.configurations.python, {
          type = "python",
          request = "launch",
          name = "Debug with .venv",
          program = "${file}",
          pythonPath = function()
              -- detect project venv
              local global_interpreter = "~/.virtualenvs/debugpy/bin/python"
              local local_env_interpreter = vim.fn.getcwd() .. "/.venv/bin/python"
              if vim.fn.executable(local_env_interpreter) == 1 then
                  return local_env_interpreter
              else
                  return global_interpreter
              end
          end,
      })
  end,
},
-- MARKS
{
    'chentoast/marks.nvim',
    config = function()
        require'marks'.setup {
            default_mappings = true,
            signs = true,
            mappings = {}
        }
    end
},
-- RUSTACEANVIM
{
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
    init = function()
        vim.g.rustaceanvim = function()
            local adapter
            local ok, mason_registry = pcall(require, "mason-registry")

            if ok then
                local has_codelldb, codelldb = pcall(mason_registry.get_package, "codelldb")

                if has_codelldb and codelldb:is_installed() then
                    local extension_path = codelldb:get_install_path() .. "/extension/"
                    local codelldb_path = extension_path .. "adapter/codelldb"
                    local liblldb_path = extension_path .. "lldb/lib/liblldb"
                    local sysname = vim.uv.os_uname().sysname

                    if sysname:find("Windows") then
                        codelldb_path = extension_path .. "adapter\\codelldb.exe"
                        liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
                    else
                        liblldb_path = liblldb_path .. (sysname == "Linux" and ".so" or ".dylib")
                    end

                    if vim.fn.executable(codelldb_path) == 1 and vim.uv.fs_stat(liblldb_path) then
                        local cfg = require("rustaceanvim.config")
                        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
                    end
                end
            end

            return {
                dap = adapter and {
                    adapter = adapter,
                } or {},
                server = {
                    on_attach = function(client, bufnr)
                        local nmap = function(keys, func, description)
                            vim.keymap.set("n", keys, func, {
                                buffer = bufnr,
                                silent = true,
                                desc = description,
                            })
                        end

                        nmap("<leader>rr", function()
                            vim.cmd.RustLsp({ "runnables" })
                        end, "Rust runnables")

                        nmap("<leader>rt", function()
                            vim.cmd.RustLsp({ "testables" })
                        end, "Rust testables")

                        nmap("<leader>rd", function()
                            vim.cmd.RustLsp({ "debuggables" })
                        end, "Rust debuggables")

                        nmap("<leader>re", function()
                            vim.cmd.RustLsp({ "explainError", "current" })
                        end, "Rust explain error")

                        nmap("<leader>rD", function()
                            vim.cmd.RustLsp({ "openDocs" })
                        end, "Rust open docs.rs")

                        nmap("<leader>rm", function()
                            vim.cmd.RustLsp({ "expandMacro" })
                        end, "Rust expand macro")

                        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                        end
                    end,
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                buildScripts = {
                                    enable = true,
                                },
                            },
                            check = {
                                command = "clippy",
                                extraArgs = { "--no-deps" },
                            },
                            procMacro = {
                                enable = true,
                            },
                        },
                    },
                },
            }
        end
    end,
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
                    -- path = "~/Dropbox/kuris_second_brain",
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
                    return require("obsidGitian").util.toggle_checkbox()
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
-- IMG - CLIP
{
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
        use_absolute_path = false,
        file_name = function ()
            local now = os.date("*t")
            local timestamp = string.format(
                "%04d%02d%02d%02d%02d%02d",
                now.year,
                now.month,
                now.day,
                now.hour,
                now.min,
                now.sec
            )
            local random_number = math.random(0, 999)
            local filename = string.format("%s__%03d", timestamp, random_number)
            return filename
        end,
        dir_path = function ()
            local Path = require("plenary.path")

            local filepath = vim.api.nvim_buf_get_name(0) -- Fetching the full path of the file in the buffer
            if filepath == "" then
                return nil -- fallback to default
            end

            local file_dir = Path:new(filepath):parent()
            local images_dir = file_dir:joinpath("images")

            -- Check if ./images exists and is a directory
            if images_dir:exists() and images_dir:is_dir() then
                return images_dir:absolute()
            end

            return 'assets'
        end
    },
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
},
-- SUPERMAVEN
{ 
    "supermaven-inc/supermaven-nvim",
    config = function()
        require("supermaven-nvim").setup({
            keymaps = {
                accept_suggestion = "<C-f>",
                clear_suggestion = "<C-]>",
                accept_word = "<C-j>",
            },
        })
    end,
},
-- MASON TOOL INSTALLER (non-LSP tools: prettier)
{
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettier",
            },
        })
    end,
},
-- CONFORM (formatting)
{
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                svelte     = { "prettier" },
                javascript = { "prettier" },
                css        = { "prettier" },
                html       = { "prettier" },
                json       = { "prettier" },
            },
            format_on_save = {
                timeout_ms = 2000,
                lsp_fallback = true,
            },
        })
    end,
},
-- Nvim-ufo
{
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.opt.foldtext = ""

    -- Use Treesitter first; fallback to indent
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    })
  end
},

})
