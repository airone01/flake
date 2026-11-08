{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-logging";
  version = "1.0.4";

  src = fetchMavenArtifact {
    groupId = "commons-logging";
    artifactId = "commons-logging";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-4mJ/JxEqLbDkv7fO3NpVJ7L+gano/HqQnEYh72jwu34=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "org/apache/commons/logging";

  excludeSourcePatterns = [
    "org/apache/commons/logging/impl/*.java"
  ];
})
