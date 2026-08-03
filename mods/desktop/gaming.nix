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
    steam.enable = true;
    gamemode.enable = true;
  };
}
