{
  lib,
  stdenv,
  fetchurl,
  jdk,
  makeWrapper,
  junit_3,
  xml-apis,
  xerces_j,
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

  depsVersions.junit = "3.8.2";
  depsVersions.xercesImpl = "2.9.1";
  depsVersions.xmlApis = "1.3.04";

  postPatch = ''
    # dist-lite depends on test-jar, which has an unconditional
    # <fail unless="junit.present"> — drop it; we don't need the test jar.
    substituteInPlace build.xml \
      --replace-fail 'depends="jars,test-jar"' 'depends="jars"'

    # Evict all binary blobs and replace with from-source builds.
    # bootstrap.sh hardcodes lib/xercesImpl.jar and lib/xml-apis.jar on the
    # classpath; we replace them so the compile classpath is blob-free.
    # dist-lite copies lib/*.jar to the output distribution, so replacing the
    # blobs also makes the shipped ant blob-free.
    # junit_3 replaces the optional junit blob; check_for_optional_packages then
    # finds junit.present and compiles JUnitTask.
    rm -f lib/xercesImpl.jar lib/xml-apis.jar \
          lib/optional/junit-*.jar lib/optional/ant-antunit-*.jar
    cp ${xml-apis}/share/java/xml-apis-${finalAttrs.depsVersions.xmlApis}.jar lib/
    cp ${xerces_j}/share/java/xercesImpl-${finalAttrs.depsVersions.xercesImpl}.jar lib/
    mkdir -p lib/optional
    cp ${junit_3}/share/java/junit-${finalAttrs.depsVersions.junit}.jar lib/optional/
  '';

  postInstall = ''
    # Verify JUnitTask compiled and all expected jars are in the distribution.
    found=0
    for j in $out/share/ant/lib/*.jar; do
      if jar tf "$j" 2>/dev/null | grep -q "JUnitTask"; then
        found=1; break
      fi
    done
    if [ $found -eq 0 ]; then
      echo "ant_1_7: JUnitTask not found — junit_3 was not picked up" >&2; exit 1
    fi
    if ! ls $out/share/ant/lib/xercesImpl-*.jar &>/dev/null; then
      echo "ant_1_7: xercesImpl jar missing from output" >&2; exit 1
    fi
    if ! ls $out/share/ant/lib/xml-apis-*.jar &>/dev/null; then
      echo "ant_1_7: xml-apis jar missing from output" >&2; exit 1
    fi
    if ! ls $out/share/ant/lib/optional/junit-*.jar &>/dev/null; then
      echo "ant_1_7: junit jar missing from lib/optional" >&2; exit 1
    fi
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
    mkdir -p $out/share/ant/lib/optional
    cp ${junit_3}/share/java/junit-${finalAttrs.depsVersions.junit}.jar \
      $out/share/ant/lib/optional/

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
