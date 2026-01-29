{
  description = "My Zola website using Anemone theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "my-zola-site";
        version = "1.0.0";

        src = ./.;

        nativeBuildInputs = [pkgs.zola];

        buildPhase = ''
          zola build
        '';

        installPhase = ''
          mkdir -p $out
          cp -r public/* $out/
        '';
      };

      devShells.default = pkgs.mkShell {
        packages = [pkgs.zola];
      };
    });
}
