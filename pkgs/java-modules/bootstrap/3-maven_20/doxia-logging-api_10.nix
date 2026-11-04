{
  ant,
  fetchurl,
  jdk8,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "doxia";
  version = "1.4";
  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://apache/maven/doxia/doxia-${finalAttrs.version}-source.tar.gz";
    hash = "sha256-1EWgla3/qMEoN+3zOEVczYb0BGNarZSV8pYiD/zX1aI=";
  };

  nativeBuildInputs = [
    ant
    jdk8
  ];

  buildPhase = ''
    runHook preBuild

    cd doxia-logging-api

    export JAVA_HOME="${jdk8.home}"
    export CLASSPATH="${jdk8}/lib/openjdk/lib/tools.jar"

    ant \
      -Dant.build.javac.source=1.4 \
      -Dant.build.javac.target=1.4 \
      jar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/commons-lang-${finalAttrs.version}.jar $out/share/java/commons-lang-${finalAttrs.version}.jar
    ln -s commons-lang-${finalAttrs.version}.jar $out/share/java/commons-lang.jar

    runHook postInstall
  '';
})
