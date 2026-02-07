{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
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
    };
  };
}
