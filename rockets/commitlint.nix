{
  system,
  nixpkgs,
  ...
}: let
  pkgs = nixpkgs.legacyPackages.${system};

  packages = with pkgs; [
    commitlint
  ];
in
  pkgs.mkShell {
    buildInputs = packages;
  }
