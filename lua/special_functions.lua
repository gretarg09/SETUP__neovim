print("loading special functions")

vim.api.nvim_set_keymap('n', '<C-l>', [[:lua ToggleCheckbox()<CR>]], { noremap = true, silent = true })

function ToggleCheckbox()
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)

    print(line)
    print(cursor)

      -- Match `[x]` or `[-]` and toggle between them
    if line:match("%[x%]") then
        line = line:gsub("%[x%]", "[-]", 1)
    elseif line:match("%[%-]") then
        line = line:gsub("%[%-]", "[x]", 1)
    end

    vim.api.nvim_set_current_line(line)
    vim.api.nvim_win_set_cursor(0, cursor) -- Restore cursor position
end
