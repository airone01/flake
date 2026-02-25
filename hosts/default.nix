{inputs, ...}: {
  flake.nixosConfigurations = let
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
  in {
    # x86_64 systems
    cassiopeia = mkSystem "cassiopeia" {system = "x86_64-linux";};
    cetus = mkSystem "cetus" {system = "x86_64-linux";};
    lyra = mkSystem "lyra" {system = "x86_64-linux";};
    # aarch64 systems
    hercules = mkSystem "hercules" {system = "aarch64-linux";};
  };
}
