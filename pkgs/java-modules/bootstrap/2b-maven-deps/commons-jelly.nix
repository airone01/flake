{
  ant,
  commons-beanutils_16,
  commons-cli_10,
  commons-collections_21,
  commons-discovery_02,
  commons-jexl,
  commons-lang_20,
  commons-logging,
  dom4j_15,
  fetchMavenArtifact,
  jaxen_11-beta-4,
  junit4,
  jdk,
  mkJavaPackage,
  servlet-api_2,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-jelly";
  version = "1.0";

  src = fetchMavenArtifact {
    groupId = "commons-jelly";
    artifactId = "commons-jelly";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-oHt/sPsSP3nfro5CYchxTPQdPjDNCm6GJn6ScYbbSKs=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "org/apache/commons/jelly";

  classpath = [
    ant
    commons-beanutils_16
    commons-cli_10
    commons-collections_21
    commons-discovery_02
    commons-jexl
    commons-lang_20
    commons-logging
    dom4j_15
    jaxen_11-beta-4
    # Might not be compatible, 3.8.1 expected, a major separates the versions
    junit4
    servlet-api_2
  ];
})
