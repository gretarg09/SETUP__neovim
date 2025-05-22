print("loading special functions")


local m = {}

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

function OpenGithub()
    local line = vim.fn.line(".")
    local cwd = vim.fn.getcwd()
    local git_root = _fetch_git_root()

    if git_root == nil then
        print('OpenGithub::Not a git repository')
        return
    end

    local remote_url = _fetch_remote_url()
    local branch = _get_current_branch()
    local relative_file_path = _get_relative_path_from_git_root(git_root)

    -- Convert SSH URL to HTTPS if necessary
    remote_url = remote_url
        :gsub("git@github.com:", "https://github.com/")
        :gsub("%.git$", "")

     local url = string.format("%s/blob/%s/%s#L%d", remote_url, branch, relative_file_path, line)

     vim.fn.jobstart({ "xdg-open", url }, { detach = true })
end

function _get_current_branch()
     local handle_branch = io.popen("git rev-parse --abbrev-ref HEAD")
     local branch = handle_branch:read("*a"):gsub("\n", "")
     handle_branch:close()

     return branch
end

function _fetch_remote_url()
    local handle_remote = io.popen("git config --get remote.origin.url")
    local remote_url = handle_remote:read("*a"):gsub("\n", "")
    handle_remote:close()

    return remote_url
end

function _get_relative_path_from_git_root(git_root)
    local file_abs_path = vim.fn.expand('%:p') -- full path to current file

    file_abs_path = vim.fn.fnamemodify(file_abs_path, ":p")
    git_root = vim.fn.fnamemodify(git_root, ":p")

    local rel_path = file_abs_path:sub(#git_root) -- +2 to skip trailing slash

    return rel_path
end

function _fetch_git_root()
    local handle = io.popen("git rev-parse --show-toplevel")
    local git_root = handle:read("*a"):gsub("\n", "")
    handle:close()

    return git_root
end

m.ToggleCheckbox = ToggleCheckbox
m.OpenGithub = OpenGithub

return m
