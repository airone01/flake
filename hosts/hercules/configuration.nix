_: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "hercules";
  system.stateVersion = "24.05"; # never change this
  time.timeZone = "Europe/Paris";

  stars = {
    mainUser = "rack";

    core = {
      enable = true;
      shellConfig = true;
    };

    server = {
      enable = true;

      ssh-server = {
        enable = true;
        permitRootLogin = "prohibit-password";
        passwordAuthentication = false;
        listenAddresses = [
          {
            addr = "0.0.0.0";
            port = 22;
          }
        ];
        allowGroups = ["wheel"];
      };

      hercules-ci.enable = true;
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
