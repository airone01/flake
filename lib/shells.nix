_: {
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

      commitlint = import ../shells/commitlint.nix {inherit pkgs;};
      website = import ../shells/website.nix {inherit pkgs;};
    };
  };
}
