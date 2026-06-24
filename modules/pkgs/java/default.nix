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
# - commons-cli:   new attr; CLI argument parsing, javac-only leaf.
# - commons-io:    new attr; IO utilities, javac-only leaf.
# - commons-lang:  new attr; java.lang extras (2.x API), javac-only leaf.
# - commons-lang3: new attr; java.lang extras (3.x API), javac-only leaf.
# - junit_3:       new attr; JUnit 3.8.2 built from Maven Central sources.jar
#                  (no public git repo); wired into ant_1_7 so JUnitTask compiles.
# - xml-apis:      new attr; W3C DOM/SAX/JAXP stubs 1.3.04 from Maven Central
#                  sources.jar; compile dep of xerces_j and ant_1_7 bootstrap.
# - xerces_j:      new attr; Xerces-J 2.9.1 from GitHub (2.9.0 has no source
#                  tarball); wired into ant_1_7 lib/ so dist-lite ships it.
{inputs, ...}: let
  overlay = final: _prev: {
    java-hamcrest = final.callPackage ./java-hamcrest/_package.nix {};
    junit_3 = final.callPackage ./junit_3/_package.nix {};
    "xml-apis" = final.callPackage ./xml-apis/_package.nix {};
    xerces_j = final.callPackage ./xerces_j/_package.nix {};
    junit_4 = final.callPackage ./junit_4/_package.nix {};
    ant_1_7 = final.callPackage ./ant_1_7/_package.nix {};
    ant = final.callPackage ./ant/_package.nix {};
    jspecify = final.callPackage ./jspecify/_package.nix {};
    jsoup = final.callPackage ./jsoup/_package.nix {};
    commons-cli = final.callPackage ./commons-cli/_package.nix {};
    commons-io = final.callPackage ./commons-io/_package.nix {};
    commons-lang = final.callPackage ./commons-lang/_package.nix {};
    commons-lang3 = final.callPackage ./commons-lang3/_package.nix {};
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
