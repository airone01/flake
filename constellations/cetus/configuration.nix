_: {
  networking.hostName = "cetus";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  stars.mainUser = "rack";

  imports = [
    # Asterisms
    ../../asterisms/server.nix

    # Hardware
    ./hardware-configuration.nix
  ];
}
