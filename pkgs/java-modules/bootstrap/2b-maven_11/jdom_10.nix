{
  fetchMavenArtifact,
  jaxen_10,
  jdk,
  mkJavaPackage,
  saxpath,
  xml-apis_10,
}:
mkJavaPackage (finalAttrs: {
  pname = "jdom";
  version = "1.0";

  src = (fetchMavenArtifact {
    groupId = "jdom";
    artifactId = "jdom";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-pvJKSsvBU9QvXz3ZM7qjoxF+gC8uyjCLccwJ1HHMawU=";
  }).overrideAttrs {name = "jdom-${finalAttrs.version}-sources";};

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  classpath = [saxpath jaxen_10 xml-apis_10];
  javaSourceDir = "org/jdom";
  excludeSourcePatterns = ["org/jdom/xpath/JaxenXPath.java"];
})
