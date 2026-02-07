{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages = import ../packages {
      inherit pkgs;
      inherit (inputs.nixpkgs) lib;
    };
  };
}
