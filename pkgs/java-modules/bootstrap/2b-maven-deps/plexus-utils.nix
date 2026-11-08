{
  classworlds,
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "plexus-utils";
  version = "1.0.5";

  src = fetchMavenArtifact {
    groupId = "org.codehaus.plexus";
    artifactId = "plexus-utils";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-eYvqec+PH8wMUuc+M6QgoFt2BHlYGZ7hC2XmEN3ZVLE=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "org/codehaus/plexus/util";

  classpath = [classworlds];

  passthru = {
    groupId = "org.codehaus.plexus";
  };
})
