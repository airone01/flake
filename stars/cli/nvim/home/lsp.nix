{pkgs, ...}: {
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;

      formatOnSave = true;

      # show code actions even when there are no lsp warns/errors
      lightbulb.enable = true;

      # "signature": box that appears when e.g. you start typing args of a function
      lspSignature.enable = true;

      # pictograms
      lspkind.enable = true;

      # lines showing errors
      lsplines.enable = true;

      # advanced lsp framework
      lspsaga = {
        enable = true;
      };

      null-ls.enable = true;
    };

    # spoken/written languages
    spellcheck = {
      enable = true;

      languages = [
        "en"
        # TODO add "fr" here and configure dictionary
      ];
    };

    # lsp languages
    languages = {
      # for each enabled language below:
      enableDAP = true;
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableLSP = true;
      enableTreesitter = true;

      # programming/scripting/configuration languages list
      html.enable = true;
      nix.enable = true;
      ts = {
        enable = true;

        extensions = {
          # make errors readable
          ts-error-translator.enable = true;
        };

        lsp.package = pkgs.nodePackages.typescript-language-server;
      };
    };
  };
}
