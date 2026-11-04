{
  fetchurl,
  hamcrestCore,
  jdk8,
  junit4,
  makeWrapper,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ant";
  version = "1.10.15";
  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://apache/ant/source/apache-ant-${finalAttrs.version}-src.tar.bz2";
    hash = "sha256-WPU+khKoAFW/FOknicf1BCBqs1uLw5dfo7cocg2A79c=";
  };

  nativeBuildInputs = [
    jdk8
    makeWrapper
  ];

  postPatch = ''
    rm -f lib/optional/junit-*.jar lib/optional/hamcrest-*.jar
    cp ${junit4}/share/java/junit-*.jar lib/optional/
    cp ${hamcrestCore}/share/java/hamcrest-*.jar lib/optional/
  '';

  buildPhase = ''
    runHook preBuild

    # export JAVA_HOME="${jdk8.out}"
    export ANT_OPTS="-Djava.home=${jdk8.home}"
    # build.sh bootstraps a small Ant with javac, then uses it to build the
    # final Ant.
    sh build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ant
    cp -r dist/* $out/share/ant/
    rm -rf $out/share/ant/bin/*.bat $out/share/ant/bin/*.cmd

    makeWrapper $out/share/ant/bin/ant $out/bin/ant \
      --set ANT_HOME $out/share/ant \
      --set JAVA_HOME ${jdk8.out}

    runHook postInstall
  '';

  strictDeps = true;
})
