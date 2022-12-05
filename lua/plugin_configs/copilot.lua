-- Sources
-- https://www.reddit.com/r/neovim/comments/sk70rk/using_github_copilot_in_neovim_tab_map_has_been/
-- https://www.google.com/search?q=copilot+neovim&source=lnms&tbm=vid&sa=X&ved=2ahUKEwiCnoWT4N_7AhVORfEDHQwsB9oQ_AUoAnoECAEQBA&biw=2749&bih=1578&dpr=1.05#fpstate=ive&vld=cid:ffe6f9a5,vid:eMnZBaOs4vM
-- https://github.com/LunarVim/LunarVim/issues/1856#issuecomment-954224770

vim.g.copilot_no_tab_map = true
vim.cmd[[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]]

vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
