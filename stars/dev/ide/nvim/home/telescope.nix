_: {
  programs.nvf.settings.vim.telescope = {
    enable = true;

    mappings = {
      findFiles = "<leader>ff";
      liveGrep = "<leader>fw";
      buffers = "<leader>fb";
      helpTags = "<leader>fh";
      gitCommits = "<leader>gc";
      lspReferences = "<leader>lr";
      lspDefinitions = "<leader>ld";
    };
  };
}
