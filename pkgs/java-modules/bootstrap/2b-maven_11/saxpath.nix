# SaxPath by Werken was merged into Jaxen after Jaxen 1.0-RCS.
{
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "saxpath";
  version = "1.0-FCS";

  src = (fetchMavenArtifact {
    groupId = "saxpath";
    artifactId = "saxpath";
    inherit (finalAttrs) version;
    classifier = "sources";
    hash = "sha256-IXe0PUWz3b67X5qU9lWLEhGUCeEvUV9xhMaHCSnW+lA=";
  }).overrideAttrs {name = "saxpath-${finalAttrs.version}-sources";};

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    mkdir -pv saxpath-${finalAttrs.version}-sources
    cd saxpath-${finalAttrs.version}-sources

    jar xf ${finalAttrs.src.jar}

    cd ..

    runHook postPatch
  '';

  javaSourceDir = "saxpath-${finalAttrs.version}-sources";
})
