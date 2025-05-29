_: {
  programs.nvf.settings.vim.filetree.neo-tree = {
    enable = true;

    setupOpts = {
      enable_cursor_hijack = true;
      # git_status_async = true; # for big repos
      auto_clean_after_session_restore = true;
    };
  };
}
