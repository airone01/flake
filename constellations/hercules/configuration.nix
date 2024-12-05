{stars, ...}: {
  networking.hostName = "hercules";
  stars.mainUser = "rack";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  imports = with stars; [
    cli-btop
    cli-eza
    cli-oh-my-posh
    cli-zellij
    cli-zsh
    core-docker
    core-font
    core-gh
    core-sops
    core-unfree
    dev-core
    dev-garnix
    r1-git
    srv-hydra
    srv-gitea
    # srv-mastodon
    # srv-matrix
    srv-phanpy
    srv-traefik
  ];

  # Booting
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    # 3002 # Mastodon
    # 3003 # Matrix
  ];
}
