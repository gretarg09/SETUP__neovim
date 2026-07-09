-- Requires agent wrapper functions in ~/.bashrc that tag the tmux pane on launch:
--   claude() { tmux set-option -p @agent "claude-${TMUX_PANE/#%/}"; command claude "$@"; }
--   codex()  { tmux set-option -p @agent "codex-${TMUX_PANE/#%/}";  command codex  "$@"; }
local M = {}

local function get_visual_selection()
    local mode = vim.fn.visualmode()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_row = start_pos[2] - 1
    local end_row = end_pos[2] - 1

    if mode == "V" then
        local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
        return table.concat(lines, "\n")
    end

    local start_col = start_pos[3] - 1
    local end_col = end_pos[3]

    -- Clamp end_col: vim sets it to 2147483647 when selection goes to end of line
    local end_line_text = vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, false)[1] or ""
    end_col = math.min(end_col, #end_line_text)

    local ok, text = pcall(vim.api.nvim_buf_get_text, 0, start_row, start_col, end_row, end_col, {})
    if not ok then return nil end
    return table.concat(text, "\n")
end

local function get_agent_panes()
    local current_pane = vim.fn.system({ "tmux", "display-message", "-p", "#{pane_id}" }):gsub("%s+", "")

    local output = vim.fn.system({
        "tmux", "list-panes",
        "-F", "#{pane_id}|#{@agent}",
    })

    local panes = {}
    for line in output:gmatch("[^\n]+") do
        local pane_id, agent = line:match("^([^|]+)|(.+)$")
        if pane_id and agent and pane_id ~= current_pane then
            table.insert(panes, {
                id = pane_id,
                display = string.format("%s [%s]", pane_id, agent),
            })
        end
    end

    return panes
end

local function send_to_pane(pane_id, text)
    vim.fn.setreg("+", text)
    vim.fn.system({ "tmux", "set-buffer", text })
    vim.fn.system({ "tmux", "paste-buffer", "-t", pane_id })
    vim.fn.system({ "tmux", "select-pane", "-t", pane_id })
end

function M.send_selection_to_agent()
    local text = get_visual_selection()
    if not text or text == "" then
        vim.notify("No text selected", vim.log.levels.WARN)
        return
    end

    local panes = get_agent_panes()

    if #panes == 0 then
        vim.notify("No agent panes found in current tmux window", vim.log.levels.WARN)
        return
    end

    if #panes == 1 then
        send_to_pane(panes[1].id, text)
        vim.notify("Sent to " .. panes[1].display, vim.log.levels.INFO)
        return
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers.new({}, {
        prompt_title = "Select Agent",
        finder = finders.new_table({
            results = panes,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.display,
                    ordinal = entry.display,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    send_to_pane(selection.value.id, text)
                    vim.notify("Sent to " .. selection.value.display, vim.log.levels.INFO)
                end
            end)
            return true
        end,
    }):find()
end

return M
