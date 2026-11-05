{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
  xml-apis_130,
  xml-resolver,
}:
mkJavaPackage (finalAttrs: {
  pname = "xerces";
  version = "2.8.1";

  src = (fetchMavenArtifact {
    groupId = "xerces";
    artifactId = "xercesImpl";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-9UbJakwPgV+i8WJBXrpnQcoskruqUfWJijYgT3Px/Fs=";
  }).overrideAttrs {name = "xerces-${finalAttrs.version}-sources";};

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    mkdir -pv xerces-${finalAttrs.version}
    cd xerces-${finalAttrs.version}

    jar xf ${finalAttrs.src.jar}

    cd ..

    runHook postPatch
  '';

  javaRelease = 8;

  classpath = [xml-apis_130 xml-resolver];

  javaSourceDir = "xerces-${finalAttrs.version}";
})
