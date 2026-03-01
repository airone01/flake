{pkgs, ...}: let
  packages = with pkgs; [
    commitlint
  ];
in
  pkgs.mkShell {
    buildInputs = packages;
  }
