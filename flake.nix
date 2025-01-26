{
  description = "r1's increasingly-less-simple NixOS config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    schizofox = {
      url = "github:schizofox/schizofox";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    systems-linux.url = "github:nix-systems/default-linux";
  };

  outputs = {
    home-manager,
    nixpkgs,
    nixos-generators,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    # Systems definition
    eachSystem = f: lib.genAttrs (import inputs.systems) (system: f system);
    eachLinuxSystem = f: lib.genAttrs (import inputs.systems-linux) (system: f system);

    # Performance and caching
    optimizations = import ./lib/optimizations.nix {inherit (inputs.nixpkgs) lib;};

    # Packages list
    outImages = ["ursamajor"];
    outFormats = ["install-iso"];

    # Utility functions
    combineArrays = arr1: arr2: f:
      builtins.listToAttrs (builtins.concatMap
        (x:
          map (y: {
            name = "${x}-${y}";
            value = f x y;
          })
          arr2)
        arr1);

    mkConstellationForPackage = system: format: hostName:
      nixos-generators.nixosGenerate {
        specialArgs = {
          inherit inputs;
        };
        inherit system format;

        modules = [
          # Optimization module
          optimizations.mkOptimizationConfig

          # Actual modules
          home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          ./constellations/${hostName}/configuration.nix
        ];
      };

    mkConstellationForNixosConfiguration = {
      constellations,
      system ? "x86_64-linux",
    }:
      lib.genAttrs constellations (name:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          inherit system;

          modules = [
            # Optimization module
            optimizations.mkOptimizationConfig
            # Libraries
            home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            ./lib/core.nix
            # Actual modules
            ./constellations/${name}/configuration.nix
          ];
        });
  in {
    # NixOS configurations
    nixosConfigurations =
      mkConstellationForNixosConfiguration {
        constellations = ["cassiopeia" "cetus"];
      }
      // mkConstellationForNixosConfiguration {
        system = "aarch64-linux";
        constellations = ["hercules"];
      };

    # Packages, including temporary setups (ISO images)
    # packages = eachLinuxSystem (system: mkPackages system);

    # Rockets
    # devShells = eachSystem (system: {
    #   default = import ./rockets {inherit system nixpkgs;};
    #   commitlint = import ./rockets/commitlint.nix {inherit system nixpkgs;};
    #   tauri = import ./rockets/tauri.nix {inherit system nixpkgs;};
    # });
  };
}
