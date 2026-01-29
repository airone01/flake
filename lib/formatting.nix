{
  inputs,
  lib,
  ...
}: let
  excludes = [
    "CHANGELOG.md"
    ".release-please-manifest.json"
  ];
in {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }:
    {
      pre-commit = {
        check.enable = true;
        settings = {
          # filename shenanigans
          excludes = map (s: "^" + lib.strings.escapeRegex s + "$") excludes;

          hooks = {
            treefmt.enable = true; # formatting and deadnix/statix fixes
          };
        };
      };

      treefmt = {
        projectRootFile = "flake.nix";
        settings.global.excludes = excludes;

        programs = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          prettier.enable = true;
          biome.enable = true;
          taplo.enable = true;
        };
      };
    }
    // import ./rockets.nix {inherit pkgs config inputs;};
}
