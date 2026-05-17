{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hostHerculesConfig = _: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops

      self.nixosModules.core
      self.nixosModules.userEnv
      self.nixosModules.server-services

      self.nixosModules.hostHerculesHardware
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

        traefik.enable = true;
        anubis.enable = true;
        website.enable = true;

        wireguard.server = {
          enable = true;
          cetusPublicKey = "j9diCNMlehtrvDgCnQfMS0qI2Q/b7Wbo5HRBIUSMUV4=";
        };
      };
    };

    services.traefik.dynamicConfigOptions.http = {
      routers = {
        searchix = {
          rule = "Host(`searchix.air1.one`)";
          service = "searchix";
          entryPoints = ["websecure"];
          tls.certResolver = "le";
        };
        gitea = {
          rule = "Host(`git.air1.one`)";
          service = "gitea";
          entryPoints = ["websecure"];
          tls.certResolver = "le";
        };
        mcheads = {
          rule = "Host(`mc.air1.one`)";
          service = "mcheads";
          entryPoints = ["websecure"];
          tls.certResolver = "le";
        };
      };
      services = {
        searchix.loadBalancer.servers = [{url = "http://10.100.0.2:3033";}]; # Anubis on Cetus
        gitea.loadBalancer.servers = [{url = "http://10.100.0.2:3031";}]; # Anubis on Cetus
        mcheads.loadBalancer.servers = [{url = "http://10.100.0.2:8080";}]; # MCHeads on Cetus
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

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
