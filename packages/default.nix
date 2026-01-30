{
  inputs,
  pkgs,
  lib,
  ...
}: {
  zola-website = pkgs.callPackage ./zola-website.nix {
    inherit lib;
    inherit (inputs) anemone-theme;
  };
}
