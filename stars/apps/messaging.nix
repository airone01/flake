{
  lib,
  pkgs,
  config,
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

  home-manager.users.${config.stars.mainUser}.programs.thunderbird = {
    enable = true;
    profiles.main.isDefault = true;
  };
}
