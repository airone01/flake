# various config elements I could not find other places to put in
{
  config.vim = {
    git = {
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

    lsp = {
      presets = {
        tailwindcss-language-server.enable = true;
        harper.enable = true;
      };

      # Language-in-language
      otter-nvim.enable = true;
    };

    # spoken languages
    spellcheck = {
      enable = true;

      languages = [
        "en"
        "fr"
        # TODO add "fr" here and configure dictionary
      ];

      # Run :DirtytalkUpdate on first use to get wordlist
      programmingWordlist.enable = true;
    };

    utility.images.image-nvim.setupOpts.backend = "kitty";

    # wrappers
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
}
