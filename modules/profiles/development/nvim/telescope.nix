{
  lib,
  config,
  ...
}: let
  cfg = config.stars;
in {
  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.development.enable
      && cfg.profiles.development.enableNvimConfig
    ) {
      home-manager.users.${config.stars.mainUser} = {
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
      };
    };
}
