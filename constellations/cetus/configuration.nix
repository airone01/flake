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
    
    # WireGuard configuration
    ./wireguard.nix

    # Hardware
    ./hardware-configuration.nix
  ];

  # Remote access
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      #PasswordAuthentication = false;
      #KbdInteractiveAuthentication = false;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRI2ynQ1ZAJWVWlk/Obhcbl+IIBDnMjvZDlWqSMvw8 rack@warrior-emu"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsNjp641wst+zLOMlTFqQTIEUi08D5yM3AKp5+LpYL r1@cassiopeia"
  ];

  networking.firewall.allowedTCPPorts = [
    22 # SSH
    # 80 # HTTP
    443 # HTTPS
    # 3001 # Gitea
  ];
}
