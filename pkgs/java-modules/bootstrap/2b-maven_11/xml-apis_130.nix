{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "xml-apis";
  version = "1.3.04";

  src = (fetchMavenArtifact {
    groupId = "xml-apis";
    artifactId = "xml-apis";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-0xAhmlcn1UJMS3qFmRs8CCGI6kITOFHNL6wG+W2DN8o=";
  }).overrideAttrs {name = "xml-apis-${finalAttrs.version}-sources";};

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    mkdir -pv xml-apis-${finalAttrs.version}
    cd xml-apis-${finalAttrs.version}

    jar xf ${finalAttrs.src.jar}

    cd ..

    runHook postPatch
  '';

  javaSourceDir = "xml-apis-${finalAttrs.version}";
})
