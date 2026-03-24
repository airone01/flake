{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.herculesConfig = _: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops

      self.nixosModules.core
      self.nixosModules.userEnv
      self.nixosModules.server-services

      self.nixosModules.herculesHardware
    ];

    networking.hostName = "hercules";
    system.stateVersion = "24.05"; # never change this
    time.timeZone = "Europe/Paris";

    stars = {
      mainUser = "rack";

      core = true;
      userEnv = true;
      server = {
        ssh.enable = true;

        hercules-ci.enable = true;
      };
    };

    users.users = {
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsNjp641wst+zLOMlTFqQTIEUi08D5yM3AKp5+LpYL r1@cassiopeia"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8rcV4x9s3V8X4QbwRZFEdKX+ddRXBFGE2fnk68hoAn user@lyra"
      ];

      rack.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsNjp641wst+zLOMlTFqQTIEUi08D5yM3AKp5+LpYL r1@cassiopeia"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8rcV4x9s3V8X4QbwRZFEdKX+ddRXBFGE2fnk68hoAn user@lyra"
      ];
    };

    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
    };
  };
}
