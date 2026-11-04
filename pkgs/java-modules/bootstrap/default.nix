{
  fetchFromGitHub,
  lib,
  newScope,
  stdenv,
}: let
  baseScope = lib.makeScope newScope (self: {
    inherit stdenv fetchFromGitHub;

    mkJavaPackage = self.callPackage ../mk-java-package.nix {};
    hamcrestCore = self.callPackage ./0-base/hamcrest-core.nix {};
  });

  junitScope = lib.makeScope newScope (self: {
    inherit stdenv fetchFromGitHub;
    inherit (baseScope) mkJavaPackage hamcrestCore;

    junit4 = self.callPackage ./1-junit/junit4.nix {};
  });

  antScope = lib.makeScope newScope (self: {
    inherit (baseScope) hamcrestCore;
    inherit (junitScope) junit4;

    ant_jdk8 = self.callPackage ./2-ant/ant_jdk8.nix {};
    ant = self.callPackage ./2-ant/ant.nix {};
  });

  maven11Scope = lib.makeScope newScope (self: {
    inherit (baseScope) mkJavaPackage;
    inherit (antScope) ant ant_jdk8;

    dom4j_161 = self.callPackage ./2b-maven_11/dom4j_161.nix {};
    dom4j_14 = self.callPackage ./2b-maven_11/dom4j_14.nix {};
    dom4j_15 = self.callPackage ./2b-maven_11/dom4j_15.nix {};
    isorelax_2002 = self.callPackage ./2b-maven_11/isorelax_2002.nix {};
    isorelax_2003 = self.callPackage ./2b-maven_11/isorelax_2003.nix {};
    jaxen_10 = self.callPackage ./2b-maven_11/jaxen_10.nix {};
    jaxen_11-beta-2 = self.callPackage ./2b-maven_11/jaxen_11-beta-2.nix {};
    jaxen_11-beta-4 = self.callPackage ./2b-maven_11/jaxen_11-beta-4.nix {};
    jaxen_11-beta-6 = self.callPackage ./2b-maven_11/jaxen_11-beta-6.nix {};
    jaxen_11-beta-9 = self.callPackage ./2b-maven_11/jaxen_11-beta-9.nix {};
    jdom_10 = self.callPackage ./2b-maven_11/jdom_10.nix {};
    maven_11 = self.callPackage ./2b-maven_11/maven_11.nix {};
    msv_2002 = self.callPackage ./2b-maven_11/msv_2002.nix {};
    relaxng-datatype_2002 = self.callPackage ./2b-maven_11/relaxng-datatype_2002.nix {};
    saxpath = self.callPackage ./2b-maven_11/saxpath.nix {};
    xsdlib_2006 = self.callPackage ./2b-maven_11/xsdlib_2006.nix {};
    xerces_281 = self.callPackage ./2b-maven_11/xerces_281.nix {};
    xml-apis_202 = self.callPackage ./2b-maven_11/xml-apis_202.nix {};
    xml-apis_10 = self.callPackage ./2b-maven_11/xml-apis_10.nix {};
    xml-apis_130 = self.callPackage ./2b-maven_11/xml-apis_130.nix {};
    xml-resolver = self.callPackage ./2b-maven_11/xml-resolver.nix {};
  });

  maven20Scope = lib.makeScope newScope (self: {
    inherit (baseScope) mkJavaPackage hamcrestCore;
    inherit (junitScope) junit4;
    inherit (antScope) ant ant_jdk8;

    commons-cli_10 = self.callPackage ./3-maven_20/commons-cli_10.nix {};
    commons-lang_10 = self.callPackage ./3-maven_20/commons-lang_10.nix {};
    doxia_10 = self.callPackage ./3-maven_20/doxia_10.nix {};
    maven_20 = self.callPackage ./3-maven_20/maven_20.nix {};
  });

  maven22Scope = lib.makeScope newScope (self: {
    inherit stdenv fetchFromGitHub;
    inherit (antScope) ant;

    maven_20 = self.callPackage ./3-maven_22/maven_20.nix {};
    maven_22 = self.callPackage ./3-maven_22/maven_22.nix {};
    commons-cli_12 = self.callPackage ./3-maven_22/commons-cli_12.nix {};
  });

  maven38Scope = lib.makeScope newScope (self: {
    inherit stdenv fetchFromGitHub;
    inherit (baseScope) mkJavaPackage hamcrestCore;
    inherit (junitScope) junit4;
    inherit (antScope) ant;

    modello = self.callPackage ./3-maven_38/modello.nix {};

    # plexusUtils = self.callPackage ./maven-core/plexus-utils.nix {};
    # plexusClassworlds = self.callPackage ./maven-core/plexus-classworlds.nix {};
    # plexusContainers = self.callPackage ./maven-core/plexus-containers.nix {};
    # modelloMinimal = self.callPackage ./maven-core/modello-minimal.nix {};
    # sisu = self.callPackage ./maven-core/sisu.nix {};
    # mavenResolver = self.callPackage ./maven-core/maven-resolver.nix {};
    # mavenWagon = self.callPackage ./maven-core/maven-wagon.nix {};
    #
    # mavenSeed = self.callPackage ./maven-core/maven-seed.nix {};
  });

  maven39Scope = lib.makeScope newScope (self: {
    maven_39 = self.callPackage ./maven_39/maven_39.nix {};
  });
  # mavenScope = lib.makeScope newScope (self: {
  #   inherit (maven39Scope) maven_39;
  #
  #   maven = self.callPackage ./maven/maven.nix {};
  # });
in {
  inherit (baseScope) mkJavaPackage;
  inherit baseScope junitScope antScope maven11Scope maven20Scope maven22Scope maven38Scope maven39Scope;

  inherit (antScope) ant junit3;
  inherit (maven22Scope) maven_20 maven_22;
  maven = maven39Scope.maven_39;
}
