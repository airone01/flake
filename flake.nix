{
  description = "r1's increasingly-less-simple NixOS config";

  inputs = {
    caddy-many = {
      url = "github:crabdancing/nixos-caddy-with-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    eachSystem = f: lib.genAttrs (import inputs.systems) (system: f system);
    eachLinuxSystem = f: lib.genAttrs (import inputs.systems-linux) (system: f system);

    mkStars = {
      system ? "x86_64-linux",
      userName,
    }:
      import ./lib/mkStars.nix {
        inherit lib userName;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true; # This only affects the evaluation of stars
        };
      };

    # List of my NixOS images
    outImages = ["ursamajor"];

    # List of formats i want to compile my images to
    outFormats = ["install-iso"];

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
          inherit
            ((mkStars {
              pkgs = nixpkgs.legacyPackages.${system};
              userName = "r1";
            }))
            stars
            ;
        };
        inherit system format;

        modules = [
          home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          (import ./lib/stars-core.nix)
          ./constellations/${hostName}/configuration.nix
        ];
      };

    mkConstellationForNixosConfiguration = {
      userName,
      constellations,
    }:
      lib.genAttrs constellations (name: let
        system = "x86_64-linux";
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit ((mkStars {inherit system userName;})) stars;
          };
          inherit system;

          modules = [
            # Enable unfree packages by default, but allow overriding
            {nixpkgs.config.allowUnfree = lib.mkDefault true;}

            home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            (import ./lib/stars-core.nix)
            ./constellations/${name}/hardware-configuration.nix
            ./constellations/${name}/configuration.nix
          ];
        });

    # Generate packages for all combinations
    mkPackages = system:
      combineArrays outImages outFormats (
        hostName: format:
          mkConstellationForPackage system format hostName
      );
  in {
    # NixOS configurations
    nixosConfigurations =
      mkConstellationForNixosConfiguration {
        userName = "r1";
        constellations = ["cassiopeia"];
      }
      // mkConstellationForNixosConfiguration {
        userName = "rack";
        constellations = ["aquarius"];
      };

    # Packages, including temporary setups (ISO images)
    packages = eachLinuxSystem (system: mkPackages system);

    # Rockets
    devShells = eachSystem (system: {
      commitlint = import ./rockets/commitlint.nix {inherit system nixpkgs;};
      tauri = import ./rockets/tauri.nix {inherit system nixpkgs;};
    });
  };
}
