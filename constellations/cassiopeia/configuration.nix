{
  pkgs,
  stars,
  config,
  ...
}: {
  networking.hostName = "cassiopeia";
  stars.mainUser = "r1";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  imports = with stars; [
    ../../asterisms/desktop.nix

    boot-plymouth
    kbd-fr
  ];

  # TODO: move that to its own star, and handle secrets with sops
  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [mullvad-vpn];
  services.mullvad-vpn.enable = true;
}
