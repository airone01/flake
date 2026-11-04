{
  fetchMavenArtifact,
  jaxen_11-beta-4,
  jdk,
  mkJavaPackage,
  relaxng-datatype_2002,
  xsdlib_2006,
}:
mkJavaPackage (finalAttrs: {
  pname = "dom4j";
  version = "1.5.2";

  src = fetchMavenArtifact {
    groupId = "dom4j";
    artifactId = "dom4j";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-qnQqQ1joIcvC39eFEddLwbgbqodpWsFcuw/Y13MsAPg=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  patches = [
    ./dom4j_15_utf8.patch
  ];

  javaSourceDir = "org";

  classpath = [jaxen_11-beta-4 relaxng-datatype_2002 xsdlib_2006];

  excludeSourcePatterns = [
    # pull-parser (org.gjt.xpp) has no source release
    "org/dom4j/xpp/*"
    "org/dom4j/io/XPP*"

    # This is excluded because of a DOM version mismatch between the current JDK and the one back then.
    # TODO: Patch the code by adding stub implementation of the abstract methods and do compile with this dir
    "org/dom4j/dom/*"
    # JAXB too
    "org/dom4j/jaxb/*"
  ];
})
