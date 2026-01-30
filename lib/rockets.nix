{
  pkgs,
  config,
  inputs,
  ...
}: {
  devShells = {
    default = pkgs.mkShell {
      inputsFrom = [
        (import ../rockets {
          inherit (pkgs) system;
          inherit (inputs) nixpkgs;
        })
      ];
      shellHook = config.pre-commit.installationScript;
    };
    commitlint = import ../rockets/commitlint.nix {
      inherit (pkgs) system;
      inherit (inputs) nixpkgs;
    };
    website = import ../rockets/zola.nix {
      inherit pkgs;
      zolaWebsite = config.packages.zola-website;
    };
  };
}
