{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  options.stars.profiles.gaming.enable = lib.mkEnableOption "gaming";

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.gaming.enable
    ) {
      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        gamescope
        lutris
        prismlauncher
        retroarch-full
        retroarch-assets
        typer
      ];

      programs = {
        # TODO: for Steam in home-manager, see
        # https://github.com/nix-community/home-manager/issues/4314
        # in the meantime:
        steam.enable = true;
        gamemode.enable = true;
      };
    };
}
