# feature: gaming programs
{
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
    ];

  environment.systemPackages = with pkgs; [
    gamescope
    lutris
    prismlauncher
    typer
  ];

  programs = {
    # TODO: for Steam in home-manager, see
    # https://github.com/nix-community/home-manager/issues/4314
    # in the meantime:
    steam.enable = true;
    gamemode.enable = true;
  };
}
