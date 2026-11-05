{
  fetchMavenArtifact,
  isorelax_2002,
  jdk,
  mkJavaPackage,
  relaxng-datatype_2002,
  xml-resolver,
  xsdlib_2006,
}:
mkJavaPackage (finalAttrs: {
  pname = "msv";
  version = "20020414";

  src = fetchMavenArtifact {
    groupId = "msv";
    artifactId = "msv";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-MxvWjCzb0e4ElZCaNzocr3xTULHfJjtpgiq1WrhFVwY=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "com/sun/msv";
  classpath = [relaxng-datatype_2002 isorelax_2002 xsdlib_2006 xml-resolver];
})
