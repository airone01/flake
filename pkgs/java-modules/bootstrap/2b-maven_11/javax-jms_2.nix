{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "javax-jms";
  version = "2.0.1";

  src = fetchMavenArtifact {
    groupId = "javax.jms";
    artifactId = "javax.jms-api";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-3mG+kjwzIXw66jvfaWISA5o770lKZ0iuGP4ZDgHIpcs=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "javax/jms";
})
