{
  description = "r1's Nix configs";

  inputs = {
    deploy-rs.url = "github:serokell/deploy-rs";
    clipboard-sync = {
      url = "github:dnut/clipboard-sync";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    searchix.url = "git+https://codeberg.org/alinnow/searchix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];

    treefmtEval = forAllSystems (
      system:
        inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
          projectRootFile = "flake.nix";
          settings.global.excludes = [
            "CHANGELOG.md"
            ".release-please-manifest.json"
            "**/*.html"
          ];

          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            prettier.enable = true;
            taplo.enable = true;
          };
        }
    );

    gitHooks = forAllSystems (
      system:
        inputs.git-hooks.lib.${system}.run {
          src = ./.;
          excludes = [
            "CHANGELOG\\.md$"
            "\\.release-please-manifest\\.json$"
            ".*\\.html$"
          ];
          hooks = {
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            prettier.enable = true;
          };
        }
    );

    nixosChecks = nixpkgs.lib.foldl' (
      acc: name: let
        host = self.nixosConfigurations.${name};
        sys = host.pkgs.stdenv.hostPlatform.system;
      in
        nixpkgs.lib.recursiveUpdate acc {
          ${sys}.${name} = host.config.system.build.toplevel;
        }
    ) {} (builtins.attrNames (self.nixosConfigurations or {}));
  in {
    packages = forAllSystems (
      system: import ./pkgs {inherit inputs system;}
    );

    formatter = forAllSystems (
      system: treefmtEval.${system}.config.build.wrapper
    );

    checks = forAllSystems (
      system: {
        formatting = treefmtEval.${system}.config.build.check self;
        pre-commit = gitHooks.${system};
      }
    );

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nh
          nix-output-monitor
          deploy-rs
          just
          nix-diff
        ];
        shellHook = gitHooks.${system}.shellHook;
      };

      commitlint = pkgs.mkShell {
        buildInputs = with pkgs; [
          commitlint
        ];
      };
    });

    nixosConfigurations = import ./hosts {inherit nixpkgs inputs;};

    githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
      checks = nixpkgs.lib.recursiveUpdate self.packages nixosChecks;
    };
  };
}
