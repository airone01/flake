{
  fetchMavenArtifact,
  javax-jms_2,
  javax-mail_14,
  jdk,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "log4j";
  version = "1.2.13";

  src = fetchMavenArtifact {
    groupId = "log4j";
    artifactId = "log4j";
    classifier = "sources";
    inherit (finalAttrs) version;
    hash = "sha256-HPncEnnJSL1KINUewns+IGV0rVJXWOLR/7+P76LHAlY=";
  };

  nativeBuildInputs = [jdk];

  unpackPhase = ''
    runHook prePatch

    jar xf ${finalAttrs.src.jar}

    runHook postPatch
  '';

  javaRelease = 8;

  javaSourceDir = "org/apache/log4j";

  classpath = [javax-jms_2 javax-mail_14];

  excludeSourcePatterns = [
    "org/apache/log4j/jmx/*"
  ];
})
