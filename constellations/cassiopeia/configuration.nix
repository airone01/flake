_: {
  networking.hostName = "cassiopeia";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  stars.mainUser = "r1";

  imports = [
    # Asterisms
    ../../asterisms/desktop.nix

    # Additional stars
    ../../stars/boot/plymouth.nix
    ../../stars/game/prismlauncher.nix
    ../../stars/kbd/fr.nix

    # Hardware
    ./hardware-configuration.nix
  ];
}
