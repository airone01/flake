_: {
  programs.nvf.settings.vim.git = {
    enable = true;
    gitsigns.enable = true;
    gitsigns.mappings = {
      nextHunk = "]c";
      previousHunk = "[c";
      stageHunk = "<leader>hs";
      resetHunk = "<leader>hr";
      previewHunk = "<leader>hp";
    };
  };
}
