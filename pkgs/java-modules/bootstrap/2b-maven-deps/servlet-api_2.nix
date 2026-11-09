{
  fetchMavenArtifact,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "servlet-api";
  version = "2.5";

  src = fetchMavenArtifact {
    groupId = "javax.servlet";
    artifactId = "servlet-api";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-3Vs12ln/BKv452P/QJuWN14cQ/sRbSZYDGgrtxWk/Fo=";
  };

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "javax/servlet";
})
