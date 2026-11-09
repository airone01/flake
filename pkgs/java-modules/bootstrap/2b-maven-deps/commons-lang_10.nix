{
  ant,
  fetchurl,
  jdk8,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "commons-lang";
  version = "1.0";
  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://apache/commons/lang/source/lang-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-1EWgla3/qMEoN+3zOEVczYb0BGNarZSV8pYiD/zX1NI=";
  };

  nativeBuildInputs = [ant jdk8];

  buildPhase = ''
    runHook preBuild

    cd lang
    # This copy is necessary for a certain Ant target
    cp ./LICENSE.txt ../LICENSE

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

    install -Dm 644 dist/commons-lang-${finalAttrs.version}.jar $out/share/java/commons-lang-${finalAttrs.version}.jar
    ln -s commons-lang-${finalAttrs.version}.jar $out/share/java/commons-lang.jar

    runHook postInstall
  '';
})
