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


function OpenImageWithSwayimg()

    -- Detects image links under the cursor and opens them with swayimg. The function supports:
    -- Markdown image syntax: ![alt](path)
    -- Direct image file paths_ image.pnd, path/to/image.png, etc.
    -- Various iamge formats: PNG, JPG, JPEG, GIF, WEBP, BMP, TIFF, and SVG files
    -- Relative and absolute paths

    local line = vim.api.nvim_get_current_line()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2] -- nvim_win_get_cursor returns a table with the cursor position: 1 for line and 2 for column
    local image_path = _find_image_at_cursor(line, cursor_col)

    if not image_path then
        print("No image found under cursor")
        return
    end

    image_path = _handle_relative_paths(image_path)

    if not _check_if_file_exists(image_path) then
        return
    end

    -- Open the image with swayimg
    _open_image(image_path)
end

function _find_image_at_cursor(line, cursor_col )

    -- Pattern to match image links: ![alt](path) or just image file paths
    local image_patterns = {
        "!%[.-%]%((.-)%)",  -- Markdown image syntax ![alt](path)
        "(%S+%.png)",       -- .png files
        "(%S+%.jpg)",       -- .jpg files
        "(%S+%.jpeg)",      -- .jpeg files
        "(%S+%.gif)",       -- .gif files
        "(%S+%.webp)",      -- .webp files
        "(%S+%.bmp)",       -- .bmp files
        "(%S+%.tiff)",      -- .tiff files
        "(%S+%.svg)"        -- .svg files
    }

    -- Find the first image link on the right of the cursor OR under the cursor (and to the right).
    local image_path = nil
    local closest_image_path = nil
    local closest_match_start = nil

    -- Find the closest image link to the right of the cursor
    for _, pattern in ipairs(image_patterns) do
        local start_pos = 1
        while start_pos <= #line do -- #line returns the length of the string that is stored in line
            local match_start, match_end, captured = string.find(line, pattern, start_pos)
            if match_start then
                -- Check if cursor is within this image link
                print(string.format("cursor_col: %d, match_start: %d, match_end: %d, captured: %s", cursor_col, match_start, match_end, captured or "nil"))
                if cursor_col >= match_start - 1 and cursor_col <= match_end then
                    if captured then
                        image_path = captured
                        break
                    else
                        print('Error: No captured text found, each statement should have a captured group so this should never happen')
                    end

                -- Check if this is the closest image link to the right of cursor
                elseif match_start > cursor_col and (not closest_match_start or match_start < closest_match_start) then
                    closest_match_start = match_start
                    if captured then
                        closest_image_path = captured
                    else
                        print('Error: No captured text found, each statement should have a captured group so this should never happen')
                    end
                end
                start_pos = match_end + 1
            else
                break
            end
        end
        if image_path then break end
    end

    -- If no image found under cursor, use the closest one to the right
    if not image_path and closest_image_path then
        image_path = closest_image_path
    end

    return image_path
end

function _check_if_file_exists(file_path)
    -- Check if file exists
    if not string.match(file_path, "^https?://") then
        local file = io.open(file_path, "r")
        if not file then
            print("Image file not found: " .. file_path)
            return false
        end
        file:close()
    end
    return true
end


function _handle_relative_paths(image_path)
    if not string.match(image_path, "^/") and not string.match(image_path, "^https?://") then
        local current_file_dir = vim.fn.expand("%:p:h")
        image_path = current_file_dir .. "/" .. image_path
    end
    return image_path
end

function _open_image(image_path)
    vim.fn.jobstart({ "swayimg", image_path }, { detach = true })
    print("Opening image: " .. image_path)
    return true
end


function InsertDateHeading()
    local date = os.date("%Y-%m-%d")
    local heading = "## " .. date
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { heading })
end

vim.api.nvim_create_user_command('Date', InsertDateHeading, {})

m.ToggleCheckbox = ToggleCheckbox
m.OpenGithub = OpenGithub
m.OpenImageWithSwayimg = OpenImageWithSwayimg
m._find_image_at_cursor = _find_image_at_cursor
m.InsertDateHeading = InsertDateHeading

return m
