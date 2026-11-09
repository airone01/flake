{
  commons-logging,
  fetchMavenArtifact,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-discovery";
  version = "0.2";

  src = fetchMavenArtifact {
    groupId = "commons-discovery";
    artifactId = "commons-discovery";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-qcRcY+Vd0IyJDEsgG025p+j741+JytvJorA0qEDRXNQ=";
  };

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  patches = [./0001-commons-discovery-enum.patch];

  javaRelease = 8;

  classpath = [commons-logging];

  javaSourceDir = "org/apache/commons/discovery";
})
