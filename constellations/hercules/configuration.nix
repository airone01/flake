_: {
  networking.hostName = "hercules";
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
    ports = [ 22 ];
    allowGroups = [ "wheel" ];

    # Optional: Enable Mosh for better mobile connections
    mosh.enable = true;

    # Any extra configuration
    extraConfig = ''
      # Add any custom sshd_config entries here
    '';
  };

  imports = [
    # Asterisms
    ../../asterisms/server.nix

    # Additional stars
    ../../stars/core/cachix.nix
    ../../stars/net/ssh-server
    ../../stars/net/wireguard
    ../../stars/srv/gitea.nix
    ../../stars/srv/hercules.nix
    ../../stars/srv/hydra.nix
    ../../stars/srv/traefik.nix

    # Hardware
    ./hardware-configuration.nix
  ];

  # Booting
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.firewall.allowedTCPPorts = [
    22 # SSH
    # 80 # HTTP
    443 # HTTPS
    # 3001 # Gitea
  ];
}
