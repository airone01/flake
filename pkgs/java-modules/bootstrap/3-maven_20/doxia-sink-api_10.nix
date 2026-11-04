{
  ant,
  fetchurl,
  jdk8,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "doxia-sink-api";
  version = "1.0";
  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://apache/maven/doxia/doxia-${finalAttrs.version}-source.tar.gz";
    hash = "sha256-1EWgla3/qMEoN+3zOEVczYb0BGNarZSV8pYiD/zX1aI=";
  };

  nativeBuildInputs = [
    ant
    jdk8
    # (ant
    #   .overrideAttrs (prevAttrs: {
    #   jdk = jdk8;
    #   installPhase = ''
    #     runHook preInstall
    #
    #     mkdir -p $out/share/ant
    #     cp -r dist/* $out/share/ant/
    #     rm -rf $out/share/ant/bin/*.bat $out/share/ant/bin/*.cmd
    #
    #     makeWrapper $out/share/ant/bin/ant $out/bin/ant \
    #       --set ANT_HOME $out/share/ant \
    #       --set JAVA_HOME "${jdk8}"
    #
    #     runHook postInstall
    #   '';
    # }))
  ];

  # hash = "sha256-aaolH/ufMTEsIdZ9sZeEPgsDs8jMPgr25uktmOsPLq0=";
  # export PATH="${jdk8_headless}/bin:''$PATH"

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

    install -Dm644 dist/commons-lang-${finalAttrs.version}.jar $out/share/java/commons-lang-${finalAttrs.version}.jar
    ln -s commons-lang-${finalAttrs.version}.jar $out/share/java/commons-lang.jar

    runHook postInstall
  '';
})
