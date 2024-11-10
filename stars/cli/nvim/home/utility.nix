_: {
  programs.nvf.settings.vim.utility = {
    # NF icon picker
    icon-picker.enable = true;

    # markdown preview with glow
    preview.glow = {
      enable = true;
      # "<leader>p"
    };

    # images support
    images.image-nvim = {
      enable = true;

      setupOpts.integrations.markdown.downloadRemoteImages = true;
    };
  };
}
