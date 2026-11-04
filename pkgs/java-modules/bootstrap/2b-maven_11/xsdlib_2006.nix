{
  fetchMavenArtifact,
  isorelax_2003,
  jdk,
  mkJavaPackage,
  relaxng-datatype_2002,
}:
mkJavaPackage (finalAttrs: {
  pname = "xsdlib";
  version = "20060615";

  src = fetchMavenArtifact {
    groupId = "com.sun.msv.datatype.xsd";
    artifactId = "xsdlib";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-jlpcl8hPxuCF2PqscqtTlSPoJhYt15umwHiCvM25194=";
  };

  nativeBuildInputs = [jdk];

  configurePhase = ''
    runHook preConfigure

    jar xf share/java/xsdlib-${finalAttrs.version}-sources.jar

    runHook postConfigure
  '';

  classpath = [relaxng-datatype_2002 isorelax_2003];
  javaSourceDir = "com/sun";

  # Xerces is ignored
  excludeSourcePatterns = ["com/sun/msv/datatype/xsd/regex/XercesImpl.java"];
})
