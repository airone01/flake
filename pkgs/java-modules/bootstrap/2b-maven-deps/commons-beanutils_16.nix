{
  commons-collections_21,
  commons-logging,
  fetchMavenArtifact,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-beanutils";
  version = "1.6.1";

  src = fetchMavenArtifact {
    groupId = "commons-beanutils";
    artifactId = "commons-beanutils";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-JiYYJjB+vm5g84OC35cjO5kF21x4Ye8gwLAqUaPs3iE=";
  };

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  patches = [
  ];

  javaRelease = 8;

  classpath = [commons-collections_21 commons-logging];

  encoding = "ISO-8859-1";
  javaSourceDir = "org/apache/commons/beanutils";
})
