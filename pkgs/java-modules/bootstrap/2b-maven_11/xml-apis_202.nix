{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "xml-apis";
  version = "2.0.2";

  src = (fetchMavenArtifact {
    groupId = "xml-apis";
    artifactId = "xml-apis";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-c2MRLv2ucWBdsxXxqcIbkc7jK39081hWddCe7XCJFdY=";
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

  patches = [./xml-apis_202_utf8.patch];
  patchFlags = ["-p1" "-d" "xml-apis-${finalAttrs.version}"];

  javaSourceDir = "xml-apis-${finalAttrs.version}";
})
