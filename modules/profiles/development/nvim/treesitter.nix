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
      && cfg.profiles.development.enableNvf
    ) {
      home-manager.users.${config.stars.mainUser} = {
        programs.nvf.settings.vim.treesitter = {
          enable = true;

          # (x?)html tag auto rename
          autotagHtml = true;

          context.enable = true;
        };
      };
    };
}
