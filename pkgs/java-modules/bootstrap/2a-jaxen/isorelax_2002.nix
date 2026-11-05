{
  ant,
  fetchMavenArtifact,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "isorelax";
  version = "20020414";

  src = (fetchMavenArtifact {
    groupId = "isorelax";
    artifactId = "isorelax";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-sjfygnm+4flRrskq09hAlz1xIreongSAXMyNZodCLi4=";
  }).overrideAttrs {name = "isorelax-${finalAttrs.version}-sources";};

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    mkdir -pv isorelax-${finalAttrs.version}
    cd isorelax-${finalAttrs.version}

    jar xf ${finalAttrs.src.jar}

    cd ..

    runHook postPatch
  '';

  patches = [./isorelax_2002_jaxp.patch];
  patchFlags = ["-p1" "-d" "isorelax-${finalAttrs.version}"];

  javaSourceDir = "isorelax-${finalAttrs.version}";

  extraClasspath = "${ant}/share/ant/lib/ant.jar";
})
