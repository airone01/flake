-- Make winbar follow theme
-- TODO: check if this one is still necessary --

vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
vim.api.nvim_set_hl(0, "WinBarNC", { link = "Comment" })
