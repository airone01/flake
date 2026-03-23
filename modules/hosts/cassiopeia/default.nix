{inputs, ...}: {
  flake.nixosConfigurations.cassiopeia = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      inherit (inputs) self;
    };
    system = "x86_64-linux";

    modules = [
      inputs.home-manager.nixosModules.home-manager

      inputs.self.nixosModules.core
      inputs.self.nixosModules.desktop
      inputs.self.nixosModules.dev
      inputs.self.nixosModules.gaming
      inputs.self.nixosModules.nvim
      inputs.self.nixosModules.virt

      inputs.self.nixosModules.cassiopeiaConfig
    ];
  };
}
