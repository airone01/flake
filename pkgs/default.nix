{
  pkgs,
  lib,
  ...
}: let
  dirContents = builtins.readDir ./.;

  isPackage = name: type:
    (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
    || (type == "directory" && builtins.pathExists (./. + "/${name}/default.nix"));

  packages = lib.filterAttrs isPackage dirContents;
in
  lib.mapAttrs' (
    name: type:
      lib.nameValuePair
      (
        if type == "regular"
        then lib.removeSuffix ".nix" name
        else name
      )
      (pkgs.callPackage (./. + "/${name}") {inherit lib;})
  )
  packages
