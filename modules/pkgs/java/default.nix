# feature: from-source Java toolchain overlay
#
# Bootstraps the Java build chain from source, heading toward a from-source
# Gradle. Each package lives as a nixpkgs-style function under
# ../pkgs/java/<name>/_package.nix (the leading underscore keeps import-tree
# from importing it as a flake-parts module); they are wired in here as a single
# overlay rather than separate flake packages so the from-source variants flow
# into every consumer of the package set.
#
# - java-hamcrest: overrides the nixpkgs (Gradle-built) package.
# - junit:         new attr (nixpkgs has no top-level junit); picks up the
#                  overridden hamcrest via `final.callPackage`.
# - ant_1_7:       new attr (does NOT override the modern `ant`); 1.7.1 is the
#                  last release fully bootstrappable from bootstrap.sh + javac.
{inputs, ...}: let
  overlay = final: _prev: {
    java-hamcrest = final.callPackage ../pkgs/java/java-hamcrest/_package.nix {};
    junit_4 = final.callPackage ../pkgs/java/junit_4/_package.nix {};
    ant_1_7 = final.callPackage ../pkgs/java/ant_1_7/_package.nix {};
  };
in {
  # Reusable overlay output (e.g. for downstream flakes or `nix build`).
  flake.overlays.java = overlay;

  # Global for the flake: flake-parts provides `pkgs` only at mkOptionDefault
  # priority, so this override wins and every per-system package set
  # (packages, devShells, `nix build .#…`) sees the overlay without a module.
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [overlay];
    };
  };

  # NixOS hosts can only receive an overlay through the module system, so this
  # can't be made module-free. Kept as its own module (out of `patches`) and
  # imported by core.nix so it reaches every host.
  flake.nixosModules.java = {nixpkgs.overlays = [overlay];};
}
