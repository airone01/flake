{
  lib,
  stdenv,
  fetchurl,
  jdk,
  makeWrapper,
  junit_3,
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

  postPatch = ''
    # dist-lite depends on test-jar, which has an unconditional
    # <fail unless="junit.present"> — drop it; we don't need the test jar.
    substituteInPlace build.xml \
      --replace-fail 'depends="jars,test-jar"' 'depends="jars"'

    # Evict binary blobs and replace the junit blob with our from-source build.
    # bootstrap.sh hardcodes lib/xercesImpl.jar and lib/xml-apis.jar on the
    # classpath and glob-adds lib/optional/*.jar. Removing xercesImpl/xml-apis
    # leaves trax.present true (JDK has javax.xml.transform.*) so the XSLT tasks
    # still compile. Replacing the junit blob with junit_3 sets junit.present and
    # compiles JUnitTask against our from-source jar instead of the blob.
    rm -f lib/xercesImpl.jar lib/xml-apis.jar \
          lib/optional/junit-*.jar lib/optional/ant-antunit-*.jar
    mkdir -p lib/optional
    cp ${junit_3}/share/java/junit-${finalAttrs.depsVersions.junit}.jar lib/optional/
  '';

  postInstall = ''
    # Verify JUnitTask was compiled (junit_3 was found by check_for_optional_packages).
    found=0
    for j in $out/share/ant/lib/*.jar; do
      if jar tf "$j" 2>/dev/null | grep -q "JUnitTask"; then
        found=1
        break
      fi
    done
    if [ $found -eq 0 ]; then
      echo "ant_1_7: JUnitTask not found in output — junit_3 was not picked up" >&2
      exit 1
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
