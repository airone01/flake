_: {
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;

      formatOnSave = true;

      # show code actions even when there are no lsp warns/errors
      lightbulb.enable = true;

      # "signature": box that appears when e.g. you start typing args of a function
      lspSignature.enable = true;

      lspconfig.enable = true;

      # pictograms
      lspkind.enable = true;

      # advanced lsp framework
      lspsaga.enable = true;

      # Language-in-language
      otter-nvim.enable = true;
    };

    diagnostics = {
      enable = true;
      config = {
        signs.text = {
          "vim.diagnostic.severity.ERROR" = "󰅚 ";
          "vim.diagnostic.severity.WARN" = "󰀪 ";
        };
      };
    };

    # spoken/written languages
    spellcheck = {
      enable = true;

      languages = [
        "en"
        # TODO add "fr" here and configure dictionary
      ];
    };
  };
}
