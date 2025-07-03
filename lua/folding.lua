print('Setting up folding')

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""

-- The ability to open and closing nearest fold with enter (but not in quickfix)
-- A quickfix buffer is a special buffer type in Vim/Neovim that displays a list of locations (files and line numbers) that you can jump to. It's identified by the filetype qf.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "qf" then
            vim.keymap.set("n", "<CR>", "za", { buffer = true, noremap = true, silent = true })
        end
    end
})
