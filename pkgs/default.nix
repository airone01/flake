{
  pkgs,
  lib,
  ...
}: let
  dirContents = builtins.readDir ./.;

  isPackageFile = name: type:
    type
    == "regular"
    && lib.hasSuffix ".nix" name
    && name != "default.nix";

  packageFiles = lib.filterAttrs isPackageFile dirContents;
in
  lib.mapAttrs' (
    name: _:
      lib.nameValuePair
      (lib.removeSuffix ".nix" name)
      (pkgs.callPackage (./. + "/${name}") {inherit lib;})
  )
  packageFiles
