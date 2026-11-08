{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "javax-mail";
  version = "1.4.7";

  src = fetchMavenArtifact {
    groupId = "javax.mail";
    artifactId = "mail";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-rqDngapXTetP/acm2r7nICJJF6hfrxXvJYg6fv5ojN4=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "javax/mail";

  excludeSourcePatterns = [
  ];
})
