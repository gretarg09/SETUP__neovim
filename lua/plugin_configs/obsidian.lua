require('obsidian').setup(
    {
        workspaces = {
            {
              name = "kuris_second_brain",
              path = "~/Git/kuris_second_brain",
            },
        },
        completion = {
            -- Set to false to disable completion.
            nvim_cmp = true,
            -- Trigger completion at 2 chars.
            min_chars = 2,
        },
        mappings = {
            ["<leader>of"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr =  true, buffer = true},
            },
            -- Toggle check-boxes "obsidian done"
            ["<leader>od"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer =  true },
            },
        },

        note_frontmatter_func = function(note)
            local out = {
                id = note.id,
                aliases = note.aliases,
                tags = note.tags,
                area = "",
                project = "",
            }

            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                for key, value in pairs(note.metadata) do
                    out[key] = value
                end
            end

            return out
        end,

        templates = {
            subdir = "Templates",
            date_format = "%Y-%m-%d-%a",
            time_format = "%H:%M",
            tags = "",
        }
    }
)
