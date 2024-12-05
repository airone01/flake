{stars, ...}: {
  networking.hostName = "cetus";
  stars.mainUser = "rack";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  imports = with stars; [
    ../../asterisms/server.nix
  ];
}
