{
  fetchMavenArtifact,
  mkJavaPackage,
  servlet-api_2,
}:
mkJavaPackage (finalAttrs: {
  pname = "jstl";
  version = "1.0.6";

  src = fetchMavenArtifact {
    groupId = "javax.servlet";
    artifactId = "jstl";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-RyJ6b+alCB1A5OEy3m8gpERbrWj0B4q4qjw/iIfTLng=";
  };

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  classpath = [servlet-api_2];

  javaSourceDir = "javax/servlet/jsp/jstl";
})
