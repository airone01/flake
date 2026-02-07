{
  pkgs,
  lib,
  ...
}: {
  astro-website = pkgs.callPackage ./astro-website.nix {
    inherit lib;
  };
}
