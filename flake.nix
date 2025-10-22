{
  description = "r1's increasingly-less-simple NixOS config";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    searchix.url = "git+https://codeberg.org/alanpearce/searchix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    home-manager,
    nixpkgs,
    nixos-wsl,
    searchix,
    sops-nix,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    defaultDarwinSystems = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    defaultLinuxSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    defaultSystems = defaultDarwinSystems ++ defaultLinuxSystems;

    # Systems definition
    eachSystem = f: lib.genAttrs defaultSystems (system: f system);
    eachLinuxSystem = f: lib.genAttrs defaultLinuxSystems (system: f system);

    mkConstellationForNixosConfiguration = {
      constellations,
      system ? "x86_64-linux",
      extraModules ? [],
    }:
      lib.genAttrs constellations (name:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          inherit system;

          modules =
            [
              home-manager.nixosModules.home-manager
              nixos-wsl.nixosModules.default
              searchix.nixosModules.web
              sops-nix.nixosModules.sops
              ./lib/core.nix
              ./constellations/${name}/configuration.nix
            ]
            ++ extraModules;
        });
  in {
    # NixOS configurations
    nixosConfigurations =
      mkConstellationForNixosConfiguration {
        constellations = ["cassiopeia" "cetus" "cygnus"];
        extraModules = [
          ({pkgs, ...}: {
            _module.args.zolaWebsite = inputs.self.packages.${pkgs.system}.zola-website;
          })
        ];
      }
      // mkConstellationForNixosConfiguration {
        system = "aarch64-linux";
        constellations = ["hercules"];
        extraModules = [
          ({pkgs, ...}: {
            _module.args.zolaWebsite = inputs.self.packages.${pkgs.system}.zola-website;
          })
        ];
      };

    packages = eachLinuxSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        customPackages = import ./packages {inherit pkgs lib;};
      in
        customPackages
    );

    # Rockets
    devShells = eachSystem (system: {
      commitlint = import ./rockets/commitlint.nix {inherit system nixpkgs;};
      default = import ./rockets {inherit system nixpkgs;};
    });
  };
}
