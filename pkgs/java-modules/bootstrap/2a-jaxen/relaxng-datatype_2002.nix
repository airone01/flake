{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "relaxng-datatype";
  version = "20020414";

  src = fetchMavenArtifact {
    groupId = "relaxngDatatype";
    artifactId = "relaxngDatatype";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-AraIEMzltWBFZhqzBkbxfpk/CmXhwaQOC+OOEvLhA2U=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "org/relaxng/datatype";
})
