{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    baseModules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.nixos-wsl.nixosModules.default
      inputs.searchix.nixosModules.web
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix

      # core modules
      ./core.nix
    ];

    # helper to reduce boilerplate
    mkSystem = name: {
      system,
      extraModules ? [],
    }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules =
          baseModules
          ++ [
            ../constellations/${name}/configuration.nix
          ]
          ++ extraModules;
      };
  in {
    # x86_64 systems
    cassiopeia = mkSystem "cassiopeia" {system = "x86_64-linux";};
    lyra = mkSystem "lyra" {system = "x86_64-linux";};

    # aarch64 systems
    hercules = mkSystem "hercules" {
      system = "aarch64-linux";
      extraModules = [
        ({pkgs, ...}: {
          _module.args.websitePackage = self.packages.${pkgs.system}.astro-website;
        })
      ];
    };
  };
}
