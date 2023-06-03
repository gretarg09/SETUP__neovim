--local colorscheme = "tokyonight"
--local colorscheme = "everforest" -- see :help everforest for more info.
local colorscheme = "catppuccin"
--local colorscheme = "bluloco"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

--vim.g.tokyonight_style = "storm"
--vim.g.tokyonight_style = "day"
