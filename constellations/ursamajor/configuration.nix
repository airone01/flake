_: {
  networking.hostName = "ursamajor";
  system.stateVersion = "25.05";
  time.timeZone = "Europe/Paris";

  stars.mainUser = "nixos";

  imports = [
    ../../asterisms/desktop-basic.nix
  ];
}
