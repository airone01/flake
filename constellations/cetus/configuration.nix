_: {
  networking.hostName = "cetus";
  system.stateVersion = "25.05"; # never change this
  time.timeZone = "Europe/Paris";

  stars.mainUser = "rack";

  # Enable Wireguard
  stars.wireguard = {
    enable = true;
    interfaceName = "wg0";
  };

  # Enable SSH server with custom configuration
  stars.ssh-server = {
    enable = true;
    permitRootLogin = "prohibit-password";
    passwordAuthentication = false;
    ports = [22];
    allowGroups = ["wheel"];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  imports = [
    # Asterisms
    ../../asterisms/server.nix

    # Network server stars
    ../../stars/srv/ssh-server
    ../../stars/srv/wireguard

    # Server stars
    ../../stars/nix/cachix.nix
    ../../stars/srv/hercules.nix

    # Hardware
    ./hardware-configuration.nix
  ];
}
