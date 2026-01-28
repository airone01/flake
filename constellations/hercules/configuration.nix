_: {
  networking.hostName = "hercules";
  system.stateVersion = "24.05"; # never change this
  time.timeZone = "Europe/Paris";

  stars.mainUser = "rack";

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
    ../../stars/srv/ssh-server
    # ../../stars/srv/wireguard
    ../../stars/srv/gitea.nix
    # ../../stars/srv/hercules.nix
    ../../stars/srv/hydra.nix
    ../../stars/srv/searchix.nix
    ../../stars/srv/traefik.nix

    # Hardware
    ./hardware-configuration.nix
  ];

  # Booting
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
