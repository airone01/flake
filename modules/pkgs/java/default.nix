# feature: from-source Java toolchain overlay
#
# Bootstraps the Java build chain from source, heading toward a from-source
# Gradle. Each package lives as a nixpkgs-style function under
# ./<name>/_package.nix (the leading underscore on the file keeps import-tree
# from importing it as a flake-parts module); they are wired in here as a single
# overlay rather than separate flake packages so the from-source variants flow
# into every consumer of the package set.
#
# - java-hamcrest: overrides the nixpkgs (Gradle-built) package.
# - junit_4:       new attr (nixpkgs has no top-level junit); picks up the
#                  overridden hamcrest via `final.callPackage`. Named junit_4 to
#                  leave room for a future `junit` (latest) package.
# - ant_1_7:       new attr (does NOT override the modern `ant`); 1.7.1 is the
#                  last release fully bootstrappable from bootstrap.sh + javac.
# - ant:           overrides the nixpkgs (binary) ant with a from-source 1.10.15
#                  built via the bootstrap ant, compiled against our junit_4.
# - jspecify:      new attr; pure nullness annotations, javac-only leaf.
# - jsoup:         new attr; HTML parser, javac build, compiled against jspecify.
{inputs, ...}: let
  overlay = final: _prev: {
    java-hamcrest = final.callPackage ./java-hamcrest/_package.nix {};
    junit_4 = final.callPackage ./junit_4/_package.nix {};
    ant_1_7 = final.callPackage ./ant_1_7/_package.nix {};
    ant = final.callPackage ./ant/_package.nix {};
    jspecify = final.callPackage ./jspecify/_package.nix {};
    jsoup = final.callPackage ./jsoup/_package.nix {};
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
