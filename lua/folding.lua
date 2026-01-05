print('Setting up folding')
-- Remember to install parsers : :TSInstall markdown markdown_inline

-- I am using nvim-ufo for a better folding experience, see plugins.lua for more folding settings.
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"


-- RE-MAP normal fold keys to use ufo.
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
-- Peek folded text (press again to jump)
vim.keymap.set('n', 'zp', function()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then vim.cmd('normal! za') end
end)

-- Create a ENTER super key for folding.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "qf" and vim.bo.buftype == "" then
      vim.keymap.set("n", "<CR>", "za", { buffer = true, noremap = true, silent = true })
    end
  end
})

-- Exclude special buffers from UFO (qf, diff, terminal).
-- This is done becuase ENTER is used differently in these buffers.
require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    if buftype ~= '' or filetype == 'qf' or filetype == 'help' or filetype == 'terminal' or filetype == 'TelescopePrompt' then
      return ''  -- disable ufo here
    end
    return { 'treesitter', 'indent' }
  end,
})

-- Remember folds per file
vim.opt.viewoptions:append("folds")

vim.api.nvim_create_autocmd("BufWinLeave", {
  callback = function() pcall(vim.cmd, "silent! mkview") end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function() pcall(vim.cmd, "silent! loadview") end,
})
