if vim.g.vscode then
    print('LOADING VSCode setup')

    require "user.vscode_keymaps"
else
    -- normal neovim setup
    print('LOADING normal neovim setup')

    require "plugins"
    require "options"
    require "keymappings"
end
