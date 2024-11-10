_: {
  programs.nvf.settings.vim.filetree.nvimTree = {
    enable = true;

    setupOpts = {
      # "prevent newly opened file from opening in the same window as the tree"
      actions.open_file.eject = false;

      # show lsp warns/errors on file tree
      diagnostics.enable = true;

      # "hijack the cursor in the tree to put it at the start of the filename"
      hijack_cursor = true;

      renderer = {
        icons.git_placement = "after";
      };
    };
  };
}
