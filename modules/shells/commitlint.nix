_: {
  perSystem = {pkgs, ...}: {
    devShells.commitlint = pkgs.mkShell {
      buildInputs = with pkgs; [commitlint];
    };
  };
}
