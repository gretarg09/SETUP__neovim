print('Setting up folding')
-- Remember to install parsers : :TSInstall markdown markdown_inline

local keymap = vim.keymap.set -- Shorten function name

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "qf" and vim.bo.buftype == "" then
        keymap('n', '<CR>', function()
              local line = vim.api.nvim_get_current_line()
              local cursor_col = vim.api.nvim_win_get_cursor(0)[2]

              -- Check if there's an image on this line
              local image_path = require('special_functions')._find_image_at_cursor(line, cursor_col)

              if image_path then
                  -- Open the image
                  print('image path found: ' .. image_path)
                  require('special_functions').OpenImageWithSwayimg()
              else
                  -- Toggle fold
                  print('no image path')
                  vim.cmd('normal! za')
              end
          end, { buffer = true, noremap = true, silent = true, desc = 'Smart Enter: Open image or toggle fold' })
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

-- Refresh folds on insert/leave. This forces neovim to update the folds when exit insert mode.
-- vim.api.nvim_create_autocmd(
--   { "TextChanged", "TextChangedI", "InsertLeave", "BufWinEnter" },
--   {
--     callback = function()
--       if vim.bo.buftype == "" then
--         vim.cmd("silent! normal! zX")
--       end
--     end,
--   }
-- )

-- Remember folds per file
vim.opt.viewoptions:append("folds")

vim.api.nvim_create_autocmd("BufWinLeave", {
  callback = function() pcall(vim.cmd, "silent! mkview") end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function() pcall(vim.cmd, "silent! loadview") end,
})
