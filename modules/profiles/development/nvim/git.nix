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
      };
    };
}
