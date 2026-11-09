{
  fetchMavenArtifact,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-lang";
  version = "2.0";

  src = fetchMavenArtifact {
    groupId = "commons-lang";
    artifactId = "commons-lang";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-r5NZl0akSnCX02tOvAF6zpJeb0MY9sMmND9bclWz/Cs=";
  };

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  patches = [./0001-commons-lang-enum.patch];

  javaRelease = 8;

  encoding = "ISO-8859-1";
  javaSourceDir = "org/apache/commons/lang";
})
