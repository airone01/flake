-- High contrast some parts of the UI --
-- TODO: check if this one is still necessary --

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Visual", {
      bg = "#3a515d", -- More blue-tinted, higher contrast
      fg = "NONE",
      reverse = false,
    })
  end,
})
