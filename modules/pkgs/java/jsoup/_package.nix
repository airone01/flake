{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdk,
  stripJavaArchivesHook,
  jspecify,
}:
# Pure-Java HTML parser, built with javac. Its only compile-time dependency is
# jspecify (nullness annotations, provided scope upstream); not propagated, as
# it isn't needed at runtime. The src/main/java9 module-info is for the modular
# multi-release jar and is intentionally skipped in this plain build.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jsoup";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "jhy";
    repo = "jsoup";
    rev = "jsoup-${finalAttrs.version}";
    hash = "sha256-Zkq2W9p8AAgeuWxze1QJfmmzwLPz4iNm6UggW5sZmJ0=";
  };

  nativeBuildInputs = [
    jdk
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p build/classes

    find src/main/java -name "*.java" > sources.txt

    javac \
      --release 8 \
      -encoding UTF-8 \
      -classpath ${jspecify}/share/java/jspecify.jar \
      -d build/classes \
      @sources.txt

    jar cf jsoup-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 jsoup-${finalAttrs.version}.jar $out/share/java/jsoup-${finalAttrs.version}.jar
    ln -s $out/share/java/jsoup-${finalAttrs.version}.jar $out/share/java/jsoup.jar

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://jsoup.org/";
    description = "Java HTML parser for real-world HTML: editing, cleaning, scraping, and XSS safety";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
