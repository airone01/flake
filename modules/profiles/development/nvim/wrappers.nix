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
        programs.nvf.settings.vim = {
          # withNodeJs = true;
          withPython3 = true;
          withRuby = true;
        };
      };
    };
}
