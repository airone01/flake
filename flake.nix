{
  description = "r1's increasingly-less-simple Nix configs";

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
    flake-parts,
    treefmt-nix,
    ...
  }:
    inputs.garnix-incrementalize.lib.withCaches (flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      imports = [
        treefmt-nix.flakeModule
        inputs.git-hooks.flakeModule

        # flake parts
        ./lib/formatting.nix
        ./lib/constellations.nix
        ./lib/packages.nix
        ./lib/rockets.nix
      ];
    });
}
