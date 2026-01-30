_: {
  programs.nvf.settings.vim = {
    # Autocomplete
    autocomplete.nvim-cmp.enable = true;

    # Auto pairs
    autopairs.nvim-autopairs.enable = true;

    # Syntax highlighting
    syntaxHighlighting = true;

    # Show static line, not relative number
    lineNumberMode = "number";

    options = {
      termguicolors = true;
    };

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
}
