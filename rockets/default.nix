{
  system,
  nixpkgs,
  ...
}: let
  pkgs = import nixpkgs {
    inherit system;
  };

  packages = with pkgs; [
    # general
    curl
    wget
    pkg-config
    openssl
    vim
    wireguard-tools
    # nix
    nh
    nix-output-monitor # nom
    alejandra
    # project-specific
    just
    bun
  ];
in
  pkgs.mkShell {
    buildInputs = packages;
  }
