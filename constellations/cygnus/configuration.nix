_: {
  networking.hostName = "cygnus";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  stars.mainUser = "r1";

  wsl.enable = true;
  wsl.defaultUser = "r1";

  imports = [
    # Asterisms
    ../../asterisms/desktop-cli.nix

    # no hardware conf since it's WSL
  ];
}
