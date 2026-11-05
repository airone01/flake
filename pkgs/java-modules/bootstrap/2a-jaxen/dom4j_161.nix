{
  fetchMavenArtifact,
  jaxen_11-beta-6,
  jdk,
  mkJavaPackage,
  relaxng-datatype_2002,
  xsdlib_2006,
}:
mkJavaPackage (finalAttrs: {
  pname = "dom4j";
  version = "1.6.1";

  src = fetchMavenArtifact {
    groupId = "dom4j";
    artifactId = "dom4j";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-TTcnX4CZGje+Rg5zsBiQFy+C/VYSU7ohMLYqel0HIi0=";
  };

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    # Extract Jaxen's DOM4J adapter to satisfy XPath
    mkdir -p org/jaxen/dom4j
    tar -xzf ${jaxen_11-beta-6.src} -C org/jaxen/dom4j --strip-components=5 jaxen-1.1-beta-6/src/java/main/org/jaxen/dom4j

    runHook postPatch
  '';

  nativeBuildInputs = [jdk];

  javaSourceDir = "org";

  classpath = [jaxen_11-beta-6 relaxng-datatype_2002 xsdlib_2006];

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
