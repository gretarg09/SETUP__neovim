local special_functions = require('special_functions')

-- MAPPING <leader l> 
-- I want to use different behaviour for <leader l> when I am in a markdown file. I am using autocommands to accomplish that.

-- Markdown-specific <leader>l mapping
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set(
        'n',
        '<leader>l',
        special_functions.ToggleCheckbox, { noremap = true, silent = true }
    )
  end,
})

-- General <leader>l mapping for other filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "markdown" then
      vim.keymap.set(
          'n',
          '<leader>l',
          vim.diagnostic.open_float,
          { buffer = args.buf, desc = 'LSP: ' .. ' Show Diagnostics'
      })
    end
  end,
})
