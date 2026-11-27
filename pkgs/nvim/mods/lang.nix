{
  config.vim = {
    lsp = {
      enable = true;

      formatOnSave = true;
      # show code actions even when there are no lsp warns/errors
      lightbulb.enable = true;
      # "signature": box that appears when e.g. you start typing args of a function
      # "lsp-signature does not work with blink.cmp. Please use blink.cmp's builtin signature feature"
      # lspSignature.enable = true;
      lspconfig.enable = true;
      # pictograms
      lspkind.enable = true;
      # advanced lsp framework
      lspsaga.enable = true;
    };

    languages =
      {
        # for each enabled language below:
        enableDAP = true;
        enableExtraDiagnostics = true;
        enableFormat = true;
        enableTreesitter = true;
      }
      // # Enabling languages
      (builtins.listToAttrs (map (name: {
        inherit name;
        value = {enable = true;};
      }) ["assembly" "astro" "bash" "clang" "css" "env" "go" "html" "json" "lua" "markdown" "nix" "php" "python" "rust" "sql" "svelte" "tex" "toml" "tsx" "typescript" "yaml" "zig"]))
      // # Setting Biome as preferred formatter
      (builtins.listToAttrs (map (name: {
        inherit name;
        value = {format.type = ["biome"];};
      }) ["astro" "css" "svelte"]))
      // {
        assembly.lsp.enable = false;
        env.extraDiagnostics.enable = true;
        nix.extraDiagnostics.enable = true;
        rust.extensions.crates-nvim.enable = true;
        tsx = {
          extraDiagnostics.enable = true;
          format.type = ["biome" "prettier"];
        };
        typescript.format.type = ["biome" "prettier"];
      };
  };
}
