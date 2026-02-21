{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  options.stars.profiles.desktop.asusPatches =
    lib.mkEnableOption "Asus computer patches";

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.desktop.enable
      && cfg.profiles.desktop.asusPatches
    ) {
      environment.systemPackages = with pkgs; [asusctl];

      services.asusd.enable = true;
    };
}
