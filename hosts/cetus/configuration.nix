{pkgs, ...}: {
  networking = {
    hostName = "cetus";
    hostId = "c2bd1785";
  };
  system.stateVersion = "25.05"; # never change this
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

  # check for zfs errors periodically
  services.zfs.autoScrub.enable = true;

  imports = [
    # Asterisms
    ../../asterisms/server.nix

    # Additional modules
    ../../modules/srv/ssh-server
    # ../../modules/srv/anubis.nix
    # ../../modules/srv/gitea.nix
    # ../../modules/srv/searchix.nix
    # ../../modules/srv/traefik.nix

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
