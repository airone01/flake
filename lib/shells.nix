{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells = {
      default = pkgs.mkShell {
        inputsFrom = [
          (import ../shells {inherit pkgs;})
        ];
        shellHook = config.pre-commit.installationScript;
      };

      commitlint = import ../shells/commitlint.nix {
        inherit (pkgs) system;
        inherit (inputs) nixpkgs;
      };
    };
  };
}
