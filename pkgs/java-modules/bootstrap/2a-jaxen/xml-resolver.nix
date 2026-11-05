{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "xml-resolver";
  version = "1.2";

  src = (fetchMavenArtifact {
    groupId = "xml-resolver";
    artifactId = "xml-resolver";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-U5FfPFGB7HEtGP3n8TqQxT2UobL2nyC2BEJNuyvlsic=";
  }).overrideAttrs {name = "xml-resolver-${finalAttrs.version}-sources";};

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  patchPhase = ''
    runHook prePatch

    # TODO: use test suite with correct runner instead
    rm -rfv org/apache/xml/resolver/tests

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "org/apache/xml/resolver";
})
