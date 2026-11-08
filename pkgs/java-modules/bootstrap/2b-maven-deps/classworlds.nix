{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "classworlds";
  version = "1.1";

  src = fetchMavenArtifact {
    groupId = "classworlds";
    artifactId = "classworlds";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-qVx1g7a8LlBUTzxAtIOQ/hHj0Pz6ldzqoBAaAzM68cM=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "org/codehaus/classworlds";
})
