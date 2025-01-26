{
  system,
  nixpkgs,
  ...
}: let
  pkgs = nixpkgs.legacyPackages.${system};

  packages = with pkgs; [
    # general
    curl
    wget
    pkg-config
    openssl
    # nix
    alejandra
    # project-specific
    just
    bun
  ];
in
  pkgs.mkShell {
    buildInputs = packages;
  }
