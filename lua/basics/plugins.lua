     
-- Automatically install and setup packer.nvim on any machine that I clone my config to.
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Automatically run :PackerCompile whenever plugins.lua is updated.
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])


-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a pop up window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Only required if you have packer configured as `opt`.
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins


    use {'nvim-tree/nvim-tree.lua', requires = {'nvim-tree/nvim-web-devicons'}, tag = 'nightly'}
    use "ryanoasis/vim-devicons" -- Dev icons for nerdtree
    use 'frazrepo/vim-rainbow'

    -- Color schema
    use 'folke/tokyonight.nvim'
    use 'sainnhe/everforest'
    use({"catppuccin/nvim", as = "catppuccin"})

    -- cmp plugins
    use "hrsh7th/nvim-cmp" -- The completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions

    use "saadparwaiz1/cmp_luasnip" -- snippet completions

    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"

    -- snippets
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "L3MON4D3/LuaSnip"
    --use({"L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*"}) 
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to used

    -- LSP
    use "neovim/nvim-lspconfig" -- enable LSP
    use "williamboman/nvim-lsp-installer" -- simple to use language server installer

    -- Formatting + LSP
    --
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
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
    }
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
    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

    -- Isort
    use 'stsewd/isort.nvim'

    use {
        'goolord/alpha-nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
    }


    -- Automatically set up the configuration after cloning packer.nvim.
    if packer_bootstrap then
      require('packer').sync()
    end
end)
