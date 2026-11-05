{
  dom4j_161,
  fetchMavenArtifact,
  jdk,
  jdom_10,
  mkJavaPackage,
  xerces_281,
}:
mkJavaPackage (finalAttrs: {
  pname = "jaxen";
  version = "1.1-beta-9";

  src = (fetchMavenArtifact {
    groupId = "jaxen";
    artifactId = "jaxen";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-JNF8irM8gTC5wQUX3yjRpykn0yCVPcmskzCYlo6fohk=";
  }).overrideAttrs {name = "jaxen-${finalAttrs.version}-sources";};

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  nativeBuildInputs = [jdk];

  javaSourceDir = "org/jaxen";

  classpath = [dom4j_161 jdom_10 xerces_281];

  excludeSourcePatterns = ["*org/jaxen/xom/*.java"];
})
