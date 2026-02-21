{pkgs, ...}: {
  networking.hostName = "hercules";
  system.stateVersion = "24.05"; # never change this
  time.timeZone = "Europe/Paris";

  stars.mainUser = "rack";

  # enable SSH server with custom configuration
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
    ../../modules/srv/ssh-server
    # ../../modules/srv/wireguard
    ../../modules/srv/anubis.nix
    ../../modules/srv/gitea.nix
    # ../../modules/srv/hercules.nix
    ../../modules/srv/searchix.nix
    ../../modules/srv/traefik.nix

    # Hardware
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    kitty # for ssh TERM type
  ];

  # Booting
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
