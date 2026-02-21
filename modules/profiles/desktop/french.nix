{
  lib,
  config,
  ...
}: let
  cfg = config.stars;
in {
  options.stars.profiles.desktop.frenchPatches =
    lib.mkEnableOption "patches for frogs";

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.desktop.enable
      && cfg.profiles.desktop.frenchPatches
    ) {
      console.keyMap = "fr";

      services.xserver.xkb = {
        layout = "fr,us";
      };

      home-manager.users.${config.stars.mainUser}.home = {
        keyboard.layout = "fr";
      };
    };
}
