{
  fetchMavenArtifact,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-collections";
  version = "2.1";

  src = fetchMavenArtifact {
    groupId = "commons-collections";
    artifactId = "commons-collections";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-DTXJnlHNUC0gA496IKACe7omU9VZYekV9o/EDKumCMw=";
  };

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  patches = [
    ./0001-commons-collections-enum.patch
    ./0002-commons-collections-map-remove-impl.patch
  ];

  javaRelease = 8;

  javaSourceDir = "org/apache/commons/collections";
})
