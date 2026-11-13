# feature: from-source Java toolchain overlay
#
# Bootstraps the Java build chain from source, heading toward a from-source
# Gradle. Each package lives as a nixpkgs-style function under
# ../pkgs/java/<name>/package.nix
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
final: _prev: {
  mkJavaPackage = final.callPackage ../pkgs/java/mk-java-package.nix {};

  ant = final.callPackage ../pkgs/java/ant/package.nix {};
  ant_1_7 = final.callPackage ../pkgs/java/ant_1_7/package.nix {};
  commons-cli = final.callPackage ../pkgs/java/commons-cli/package.nix {};
  commons-io = final.callPackage ../pkgs/java/commons-io/package.nix {};
  commons-lang = final.callPackage ../pkgs/java/commons-lang/package.nix {};
  commons-lang3 = final.callPackage ../pkgs/java/commons-lang3/package.nix {};
  java-hamcrest = final.callPackage ../pkgs/java/java-hamcrest/package.nix {};
  jsoup = final.callPackage ../pkgs/java/jsoup/package.nix {};
  jspecify = final.callPackage ../pkgs/java/jspecify/package.nix {};
  junit_3 = final.callPackage ../pkgs/java/junit_3/package.nix {};
  junit_4 = final.callPackage ../pkgs/java/junit_4/package.nix {};
  xerces_j = final.callPackage ../pkgs/java/xerces_j/package.nix {};
  xml-apis = final.callPackage ../pkgs/java/xml-apis/package.nix {};
}
