{
  lib,
  stdenvNoCC,
  fetchurl,
  jdk,
  stripJavaArchivesHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "junit";
  version = "3.8.2";

  # No public git repository for JUnit 3.x; sourced from Maven Central sources.jar
  # (same situation as aopalliance). fetchzip can't unpack .jar extensions, so
  # we use fetchurl and extract manually with `jar xf` in buildPhase.
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/junit/junit/${finalAttrs.version}/junit-${finalAttrs.version}-sources.jar";
    hash = "sha256-eQSHmRRBcRItEPj1e7r1QjieVFKnIQwmNgAFSOmEB4o=";
  };

  nativeBuildInputs = [
    jdk
    stripJavaArchivesHook
  ];

  unpackPhase = "true";

  buildPhase = ''
    runHook preBuild

    jar xf $src

    mkdir -p build/classes
    find . -name "*.java" \
      ! -path "./junit/tests/*" \
      ! -path "./junit/samples/*" \
      > sources.txt

    javac --release 8 -encoding UTF-8 -d build/classes @sources.txt
    jar cf junit-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 junit-${finalAttrs.version}.jar \
      $out/share/java/junit-${finalAttrs.version}.jar
    ln -s $out/share/java/junit-${finalAttrs.version}.jar \
      $out/share/java/junit.jar

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "JUnit 3 testing framework for Java";
    homepage = "https://junit.org/junit4/";
    license = lib.licenses.cpl10;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
