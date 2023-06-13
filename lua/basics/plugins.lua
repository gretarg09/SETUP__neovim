local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

    use {'nvim-tree/nvim-tree.lua', requires = {'nvim-tree/nvim-web-devicons'}, tag = 'nightly'}
    use "ryanoasis/vim-devicons" -- Dev icons for nerdtree
    use 'frazrepo/vim-rainbow'
    use { "ray-x/lsp_signature.nvim",}

    -- Color schema
    use 'folke/tokyonight.nvim'
    use 'sainnhe/everforest'
    use({"catppuccin/nvim", as = "catppuccin"})
    use {'uloco/bluloco.nvim', requires = { 'rktjmp/lush.nvim' } }
    use({
      "neanias/everforest-nvim",
      -- Optional; default configuration will be used if setup isn't called.
      config = function()
        require("everforest").setup()
      end,
    })

    use { -- Autocompletion
        'hrsh7th/nvim-cmp',
         requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    }

    use { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
          requires = {
              -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

      --     Useful status updates for LSP
            'j-hui/fidget.nvim',

            -- Additional lua configuration, makes nvim stuff amazing
            'folke/neodev.nvim',
        },
    }

	use {'hrsh7th/cmp-buffer'}
	use	{'hrsh7th/cmp-path'}
	use	{'hrsh7th/cmp-nvim-lua'}
	use {'rafamadriz/friendly-snippets'}

    use "hrsh7th/cmp-nvim-lsp"

  -- Formatting + LSP
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })

    -- Telescope
    use "nvim-telescope/telescope.nvim"
    use 'nvim-telescope/telescope-media-files.nvim'

    -- Statusline
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", }

    use "p00f/nvim-ts-rainbow"

    use {'phaazon/hop.nvim', -- A rewrite of easymotion
      branch = 'v1', -- optional but strongly recommended
      config = function()
             -- you can configure Hop the way you like here; see :h hop-config
              require('hop').setup { keys = 'etovxqpdygfblzhckisuran'}
    end}

    -- Debugger
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-dap-python'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'nvim-telescope/telescope-dap.nvim'

    -- Outline
    use 'simrat39/symbols-outline.nvim' -- I am not sure about this plugin. Need to test it.

    -- Blankline
    use "lukas-reineke/indent-blankline.nvim"

    -- Markdown
    --use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    -- Isort
    use 'stsewd/isort.nvim'

    use {
        'goolord/alpha-nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
    }

    -- Copilot
    use "github/copilot.vim"
    -- use "zbirenbaum.copilot.lua" -- is an alternive that is written in pure lua.

    -- Git
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }


    --Rainbow CSV
    use "mechatroner/rainbow_csv"

    -- Markers
    use "chentoast/marks.nvim"
    use "ThePrimeagen/harpoon"

    -- Commenting
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)


-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})
