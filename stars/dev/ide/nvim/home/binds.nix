_: {
  programs.nvf.settings.vim = {
    binds = {
      # cheat sheet with all binds
      cheatsheet.enable = true;
      # shows menu with corresponding keys when typing
      whichKey.enable = true;
    };

    # Custom keymaps
    maps = {
      # jk to escape insert mode
      insert = {
        "jk" = {
          action = "<Esc>";
          silent = true;
          desc = "Exit insert mode";
        };
      };

      # Code actions, format
      normal = {
        "<leader>ca" = {
          action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          silent = true;
          desc = "Code actions";
        };
        "<leader>fm" = {
          action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
          silent = true;
          desc = "Format buffer";
        };
      };
    };
  };
}
