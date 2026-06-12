{
  lib,
  stdenv,
  fetchurl,
  jdk,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ant";
  version = "1.7.1";

  src = fetchurl {
    url = "mirror://apache/ant/source/apache-ant-${finalAttrs.version}-src.tar.bz2";
    hash = "sha256-TcSacmDvkKbcZhG36WufBH1QdYlzbUoq1u++Pt/G+6Y=";
  };

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  postPatch = ''
    # The bootstrap target (-> dist-lite) depends on test-jar, which hard-fails
    # with `<fail unless="junit.present">`. We bootstrap with javac only (no
    # JUnit), and a bootstrap ant doesn't need the test-utility jar, so drop
    # that dependency. dist-lite just copies whatever jars were built, so the
    # runnable distribution is unaffected.
    substituteInPlace build.xml \
      --replace-fail 'depends="jars,test-jar"' 'depends="jars"'
  '';

  buildPhase = ''
    runHook preBuild

    # build.xml pins javac source/target to 1.2/1.3, which a modern javac
    # rejects (minimum is 8). bootstrap.sh forwards its arguments into the ant
    # invocation that drives the build, and -D overrides the in-file <property>
    # defaults. JDK feature detection in build.xml is class-existence based
    # (e.g. java.net.Proxy for jdk1.5+), so every source still compiles here.
    sh bootstrap.sh -Djavac.source=8 -Djavac.target=8

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/ant
    cp -r bootstrap/* $out/share/ant/
    rm -rf $out/share/ant/bin/*.bat

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
