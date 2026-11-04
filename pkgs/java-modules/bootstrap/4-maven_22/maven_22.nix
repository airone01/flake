{
  ant,
  fetchurl,
  jdk_headless,
  makeWrapper,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "maven";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://apache/maven/maven-2/${finalAttrs.version}/source/apache-maven-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-AkM0hsVfnz6xGv+7TYljOcuTquMz8y/RfC7C/P/zRpA=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ant makeWrapper];

  buildPhase = ''
    runHook preBuild

    export M2_HOME="$out/apache-maven-${finalAttrs.version}"
    mkdir -vp "''${M2_HOME}"

    cd apache-maven-${finalAttrs.version}
    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # makeWrapper $out/maven/bin/mvn $out/bin/mvn \
    #   --set-default JAVA_HOME "${jdk_headless}"
    # makeWrapper $out/maven/bin/mvnDebug $out/bin/mvnDebug \
    #   --set-default JAVA_HOME "${jdk_headless}"

    runHook postInstall
  '';
})
