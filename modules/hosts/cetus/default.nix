{inputs, ...}: {
  flake.nixosConfigurations.cetus = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      inherit (inputs) self;
    };
    system = "x86_64-linux";

    modules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops

      inputs.self.nixosModules.core
      inputs.self.nixosModules.server-services

      inputs.self.nixosModules.cetusConfig
    ];
  };
}
