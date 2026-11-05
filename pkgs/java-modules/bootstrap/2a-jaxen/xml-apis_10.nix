{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "xml-apis";
  version = "1.0.b2";

  src = (fetchMavenArtifact {
    groupId = "xml-apis";
    artifactId = "xml-apis";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-Rp8X2KNMumVUdpsr5/0HJ8HKKFNseSm7wVcnU0UrWWo=";
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

  patches = [./xml-apis_10_enum.patch];
  patchFlags = ["-p1" "-d" "xml-apis-${finalAttrs.version}"];

  # patchPhase = ''
  #   runHook prePatch
  #
  #   # TODO: use test suite with correct runner instead
  #   rm -rfv org/apache/xml/resolver/tests
  #
  #   runHook postPatch
  # '';

  javaSourceDir = "xml-apis-${finalAttrs.version}";
})
