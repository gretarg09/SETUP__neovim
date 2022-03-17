local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("plugin_configs.lsp.lsp-installer")
require("plugin_configs.lsp.handlers").setup()


-- > inital setup made according to:
-- https://github.com/LunarVim/Neovim-from-scratch/tree/06-LSP
-- https://www.youtube.com/watch?v=OhnLevLpGB4&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ&index=9
