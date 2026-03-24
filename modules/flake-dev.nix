# feature: flake development tooling
{inputs, ...}: let
  treefmtExcludes = [
    "CHANGELOG.md"
    ".release-please-manifest.json"
    "**/*.html"
  ];
  preCommitExcludes = [
    "CHANGELOG\\.md$"
    "\\.release-please-manifest\\.json$"
    ".*\.html$"
  ];
in {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
  ];

  perSystem = {pkgs, ...}: {
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

    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        nh
        nix-output-monitor # nom
        deploy-rs
        just
      ];
    };

    devShells.commitlint = pkgs.mkShell {
      buildInputs = with pkgs; [commitlint];
    };
  };
}
