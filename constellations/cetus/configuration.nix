_: {
  networking.hostName = "cetus";
  system.stateVersion = "24.05";
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

  imports = [
    # Asterisms
    ../../asterisms/server.nix

    # Additional stars
    ../../stars/core/cachix.nix
    ../../stars/net/ssh-server
    ../../stars/net/wireguard

    # Server stars
    ../../stars/srv/hercules.nix
    ../../stars/srv/vaultwarden.nix

    # Hardware
    ./hardware-configuration.nix
  ];
}
