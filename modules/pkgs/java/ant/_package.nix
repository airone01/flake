{
  lib,
  stdenv,
  fetchurl,
  jdk,
  makeWrapper,
  junit_4,
  java-hamcrest,
}:
# Built from source (nixpkgs ships ant as a binary distribution). build.sh
# first bootstraps a minimal ant with javac, then drives the full build with
# that bootstrap ant. The JUnit optional tasks and the test jar are compiled
# against JUnit, which the build discovers on the classpath via lib/optional;
# we swap the pre-built binaries shipped there for our from-source junit_4 and
# java-hamcrest. JUnit 5 (junitlauncher) stays absent, so those tasks are
# skipped — junit_4 is enough for a JUnit 4 capable ant.
stdenv.mkDerivation (finalAttrs: {
  pname = "ant";
  version = "1.10.15";

  src = fetchurl {
    url = "mirror://apache/ant/source/apache-ant-${finalAttrs.version}-src.tar.bz2";
    hash = "sha256-WPU+khKoAFW/FOknicf1BCBqs1uLw5dfo7cocg2A79c=";
  };

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  postPatch = ''
    # Replace the binary JUnit/Hamcrest jars shipped in the source tree with our
    # from-source builds. build.sh adds lib/optional to the build classpath, so
    # the JUnit tasks and tests compile against these. Our java-hamcrest is a
    # single merged jar (vs upstream's split core/library 1.3 jars).
    rm -f lib/optional/junit-*.jar lib/optional/hamcrest-*.jar
    cp ${junit_4}/share/java/junit-*.jar lib/optional/
    cp ${java-hamcrest}/share/java/hamcrest-*.jar lib/optional/
  '';

  buildPhase = ''
    runHook preBuild

    # build.sh bootstraps with javac if needed, then runs the bootstrap ant on
    # the default `main` target, producing a minimal distribution in ./dist.
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
      --set JAVA_HOME ${jdk.home}

    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    homepage = "https://ant.apache.org/";
    description = "Java-based build tool";
    sourceProvenance = with lib.sourceTypes; [fromSource];
    license = lib.licenses.asl20;
    teams = [lib.teams.java];
    platforms = lib.platforms.all;
    mainProgram = "ant";
  };
})
