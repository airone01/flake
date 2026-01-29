{
  description = "r1's increasingly-less-simple NixOS config";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    garnix-incrementalize.url = "github:garnix-io/incrementalize";
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
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    treefmt-nix,
    ...
  }:
    inputs.garnix-incrementalize.lib.withCaches (flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      imports = [
        treefmt-nix.flakeModule
        inputs.git-hooks.flakeModule
      ];

      perSystem = {
        pkgs,
        system,
        config,
        ...
      }: {
        packages = import ./packages {
          inherit pkgs;
          inherit (nixpkgs) lib;
        };

        devShells = {
          default = pkgs.mkShell {
            shellHook = config.pre-commit.installationScript;
            inputsFrom = [
              (import ./rockets {inherit system nixpkgs;})
            ];
          };
          commitlint = import ./rockets/commitlint.nix {inherit system nixpkgs;};
        };

        treefmt = {
          projectRootFile = "flake.nix";
          settings.global.excludes = [
            "CHANGELOG.md"
          ];

          programs = {
            alejandra.enable = true;
            deadnix.enable = true; # dead vard
            prettier.enable = true; # MD, JSON, YAML
            biome.enable = true; # JS, TS
            taplo.enable = true; # TOML
          };
        };
      };

      flake = let
        mkConstellation = {
          constellations,
          system ? "x86_64-linux",
          extraModules ? [],
        }:
          nixpkgs.lib.genAttrs constellations (
            name:
              nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {inherit inputs;};
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
              }
          );
      in {
        nixosConfigurations =
          # x86_64 systems
          (mkConstellation {
            constellations = ["cassiopeia" "lyra"];
            system = "x86_64-linux";
          })
          //
          # aarch64 systems
          (mkConstellation {
            constellations = ["hercules"];
            system = "aarch64-linux";
            extraModules = [
              ({pkgs, ...}: {
                _module.args.zolaWebsite = self.packages.${pkgs.system}.zola-website;
              })
            ];
          });
      };
    });
}
