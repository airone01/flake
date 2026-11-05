{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
  saxpath,
}:
mkJavaPackage (finalAttrs: {
  pname = "jaxen";
  version = "1.0-FCS";

  src = (fetchMavenArtifact {
    groupId = "jaxen";
    artifactId = "jaxen";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-KZqIbMBdrmyec4p388CajpcqezHzSA2AOJ41wuGJ2Zk=";
  }).overrideAttrs {name = "jaxen-${finalAttrs.version}-sources";};

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  patches = [./jaxen_10_enum.patch];

  javaRelease = 8;

  classpath = [saxpath];
  javaSourceDir = "org/jaxen";
  excludeSourcePatterns = ["org/jaxen/jdom/*.java" "org/jaxen/dom4j/*.java" "org/jaxen/dom/*.java" "org/jaxen/exml/*.java"];
})
