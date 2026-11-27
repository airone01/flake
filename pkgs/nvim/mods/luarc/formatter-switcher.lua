-- Switch between my main formatters when programming for the JS ecosystem
-- TODO: Make it switch between all formatters, don't hardcode Biome and Prettier
-- TODO: There probably is already a quick vim command for this, I just need to search

-- Prettier
vim.api.nvim_create_user_command("UsePrettier", function()
  local conform = require("conform")
  local web_fts = { "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "astro", "css" }

  for _, ft in ipairs(web_fts) do
    conform.formatters_by_ft[ft] = { "prettier" }
  end

  vim.notify("Formatter switched to Prettier", vim.log.levels.INFO)
end, {})

-- BiomeJS
vim.api.nvim_create_user_command("UseBiome", function()
  local conform = require("conform")
  local web_fts = { "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "astro", "css" }

  for _, ft in ipairs(web_fts) do
    conform.formatters_by_ft[ft] = { "biome" }
  end

  vim.notify("Formatter switched to Biome", vim.log.levels.INFO)
end, {})
