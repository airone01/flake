{
  lib,
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [
    discord
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
    ];
}
