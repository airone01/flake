_: {
  networking.hostName = "cygnus";
  system.stateVersion = "25.05"; # never change this
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
