{inputs, ...}: let
  mkSystem = name: {
    system,
    extraModules ? [],
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = with inputs;
        [
          home-manager.nixosModules.home-manager
          nixos-wsl.nixosModules.default
          searchix.nixosModules.web
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix

          ../modules
          ../hosts/${name}/configuration.nix
        ]
        ++ extraModules;
    };

  nixosConfigs = {
    cassiopeia = mkSystem "cassiopeia" {system = "x86_64-linux";};
    cetus = mkSystem "cetus" {system = "x86_64-linux";};
    lyra = mkSystem "lyra" {system = "x86_64-linux";};
    hercules = mkSystem "hercules" {system = "aarch64-linux";};
  };
in {
  flake.nixosConfigurations = nixosConfigs;

  flake.deploy.nodes = {
    cetus = {
      hostname = "cetus.gotdns.ch";

      fastConnection = true;
      magicRollback = true;
      autoRollback = true;

      profiles.system = {
        sshUser = "rack";
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigs.cetus;
      };
    };

    hercules = {
      hostname = "84.235.228.86";

      fastConnection = false;
      magicRollback = true;
      autoRollback = true;

      # aarch64 can't be built locally on most of my systems
      remoteBuild = true;

      profiles.system = {
        sshUser = "rack";
        user = "root";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos nixosConfigs.hercules;
      };
    };
  };
}
