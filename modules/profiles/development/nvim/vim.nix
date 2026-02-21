{
  lib,
  config,
  ...
}: let
  cfg = config.stars;
in {
  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.development.enable
      && cfg.profiles.development.enableNvf
    ) {
      home-manager.users.${config.stars.mainUser} = {
        programs.nvf.settings.vim = {
          autocomplete.nvim-cmp.enable = true;
          autopairs.nvim-autopairs.enable = true;
          syntaxHighlighting = true;
          # show static line, not relative number
          lineNumberMode = "number";
          options.termguicolors = true;

          luaConfigRC = {
            # Better jk escape with timeout
            better-escape = ''
              vim.o.timeoutlen = 300
              vim.o.ttimeoutlen = 10
            '';

            # Make winbar follow theme
            winbar-theme = ''
              vim.api.nvim_set_hl(0, 'WinBar', { link = 'Normal' })
              vim.api.nvim_set_hl(0, 'WinBarNC', { link = 'Comment' })
            '';

            visual-high-contrast = ''
              vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                  vim.api.nvim_set_hl(0, 'Visual', {
                    bg = '#3a515d',  -- More blue-tinted, higher contrast
                    fg = 'NONE',
                    reverse = false
                  })
                end,
              })
            '';
          };
        };
      };
    };
}
