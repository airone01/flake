{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    thunderbird
    discord
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
    ];

  stars.home.programs.thunderbird = {
    enable = true;
    profiles.main.isDefault = true;
  };
}
