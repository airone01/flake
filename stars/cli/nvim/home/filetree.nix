_: {
  programs.nvf.settings.vim.filetree.neo-tree = {
    enable = true;

    setupOpts = {
      enable_cursor_hijack = true;

      # For big repos
      git_status_async = true;
    };
  };
}
