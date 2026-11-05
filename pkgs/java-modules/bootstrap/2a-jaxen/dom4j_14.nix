{
  fetchMavenArtifact,
  jaxen_10,
  jdk,
  mkJavaPackage,
  relaxng-datatype_2002,
  saxpath,
  xsdlib_2006,
}:
mkJavaPackage (finalAttrs: {
  pname = "dom4j";
  version = "1.4";

  src = fetchMavenArtifact {
    groupId = "dom4j";
    artifactId = "dom4j";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-UytgqHwexkkG9bOQgLq0szF0mdBWg8RfXsEZwxrafIA=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    # Extract Jaxen's DOM4J adapter classes to satisfy XPath
    jar xf ${jaxen_10.src.jar} org/jaxen/dom4j

    runHook postPatch
  '';

  patches = [
    ./dom4j_14_enum.patch
    ./dom4j_14_utf8.patch
    # ./dom4j_14_dom3.patch
  ];

  javaSourceDir = "org";

  classpath = [jaxen_10 relaxng-datatype_2002 saxpath xsdlib_2006];

  excludeSourcePatterns = [
    # pull-parser (org.gjt.xpp) has no source release
    "org/dom4j/xpp/*"
    "org/dom4j/io/XPP*"

    # This is excluded because of a DOM version mismatch between the current JDK and the one back then.
    # TODO: Patch the code by adding stub implementation of the abstract methods and do compile with this dir
    "org/dom4j/dom/*"
  ];
})
