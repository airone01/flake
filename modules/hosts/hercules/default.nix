{inputs, ...}: {
  flake.nixosConfigurations.hercules = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      inherit (inputs) self;
    };
    system = "aarch64-linux";

    modules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops

      inputs.self.nixosModules.core
      inputs.self.nixosModules.server-services

      inputs.self.nixosModules.herculesConfig
    ];
  };
}
