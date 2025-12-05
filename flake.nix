{
  description = "r1's increasingly-less-simple NixOS config";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;

    defaultLinuxSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    # Systems definition
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
              inputs.home-manager.nixosModules.home-manager
              inputs.nixos-wsl.nixosModules.default
              inputs.searchix.nixosModules.web
              inputs.sops-nix.nixosModules.sops
              inputs.stylix.nixosModules.stylix
              ./lib/core.nix
              ./constellations/${name}/configuration.nix
            ]
            ++ extraModules;
        });
  in {
    # NixOS configurations
    nixosConfigurations =
      mkConstellationForNixosConfiguration {
        constellations = ["cassiopeia" "cetus" "cygnus" "lyra"];
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
    devShells = eachLinuxSystem (system: {
      commitlint = import ./rockets/commitlint.nix {inherit system nixpkgs;};
      default = import ./rockets {inherit system nixpkgs;};
    });
  };
}
