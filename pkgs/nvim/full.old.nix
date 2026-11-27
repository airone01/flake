{
  pkgs,
  inputs,
  ...
}:
(inputs.nvf.lib.neovimConfiguration
  {
    inherit pkgs;
    modules = [
      {
        config.vim = {
          # luaConfigRC = {
          #   better-escape = ''
          #     -- Better `jk` escape with timeout
          #     vim.o.timeoutlen = 300
          #     vim.o.ttimeoutlen = 10
          #   '';
          #
          #   suppress-null-ls-warning = ''
          #     -- Suppress null-ls deprecation warnings
          #     local notify = vim.notify
          #     vim.notify = function(msg, ...)
          #       if msg:match("null%-ls") then
          #         return
          #       end
          #       notify(msg, ...)
          #     end
          #   '';
          #
          #   winbar-theme = ''
          #     -- Make winbar follow theme
          #     vim.api.nvim_set_hl(0, 'WinBar', { link = 'Normal' })
          #     vim.api.nvim_set_hl(0, 'WinBarNC', { link = 'Comment' })
          #   '';
          #
          #   visual-high-contrast = ''
          #     vim.api.nvim_create_autocmd("ColorScheme", {
          #       pattern = "*",
          #       callback = function()
          #         vim.api.nvim_set_hl(0, 'Visual', {
          #           bg = '#3a515d',  -- More blue-tinted, higher contrast
          #           fg = 'NONE',
          #           reverse = false
          #         })
          #       end,
          #     })
          #   '';
          #
          #   formatter-switcher = ''
          #     -- prettier
          #     vim.api.nvim_create_user_command("UsePrettier", function()
          #       local conform = require("conform")
          #       local web_fts = {"javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "astro", "css"}
          #
          #       for _, ft in ipairs(web_fts) do
          #         conform.formatters_by_ft[ft] = { "prettier" }
          #       end
          #
          #       vim.notify("Formatter switched to Prettier", vim.log.levels.INFO)
          #     end, {})
          #
          #     -- biome
          #     vim.api.nvim_create_user_command("UseBiome", function()
          #       local conform = require("conform")
          #       local web_fts = {"javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "astro", "css"}
          #
          #       for _, ft in ipairs(web_fts) do
          #         conform.formatters_by_ft[ft] = { "biome" }
          #       end
          #
          #       vim.notify("Formatter switched to Biome", vim.log.levels.INFO)
          #     end, {})
          #   '';
          # };
        };
      }
    ];
  }).neovim
