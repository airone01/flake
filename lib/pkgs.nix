{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages = import ../pkgs {
      inherit pkgs;
      inherit (inputs.nixpkgs) lib;
    };
  };
}
