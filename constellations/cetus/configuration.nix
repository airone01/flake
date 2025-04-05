_: {
  networking.hostName = "cetus";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  stars.mainUser = "rack";

  imports = [
    # Asterisms
    ../../asterisms/server.nix

    # Additional stars
    ../../stars/core/cachix.nix
    ../../stars/srv/hercules.nix

    # Hardware
    ./hardware-configuration.nix
  ];
}
