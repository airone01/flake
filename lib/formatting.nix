{inputs, ...}: let
  treefmtExcludes = [
    "CHANGELOG.md"
    ".release-please-manifest.json"
    "packages/website/**"
  ];
  preCommitExcludes = [
    "CHANGELOG\\.md$"
    "\\.release-please-manifest\\.json$"
    "packages/website/.*$"
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
          excludes = preCommitExcludes;

          hooks = {
            treefmt.enable = true; # formatting and deadnix/statix fixes
          };
        };
      };

      treefmt = {
        projectRootFile = "flake.nix";
        settings.global.excludes = treefmtExcludes;

        programs = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          prettier.enable = true;
          taplo.enable = true;
        };
      };
    }
    // import ./rockets.nix {inherit pkgs config inputs;};
}
