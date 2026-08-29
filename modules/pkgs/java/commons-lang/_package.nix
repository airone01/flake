{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdk,
  stripJavaArchivesHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "commons-lang";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-lang";
    rev = "LANG_2_6";
    hash = "sha256-7fjU0OKkHeyPZvZZ0lmWrxym8huTGEPvNwiUMpOcquk=";
  };

  nativeBuildInputs = [
    jdk
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p build/classes

    # The lang/enum/ package uses 'enum' as a directory/package name, which
    # became a reserved keyword in Java 5. Exclude it; the lang/enums/ package
    # (with 's') provides the same functionality and compiles cleanly.
    # Sources are Latin-1 encoded (pre-Maven UTF-8 convention).
    find src/main/java -name "*.java" \
      ! -path "*/lang/enum/*" > sources.txt

    javac \
      --release 8 \
      -encoding ISO-8859-1 \
      -d build/classes \
      @sources.txt

    jar cf commons-lang-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 commons-lang-${finalAttrs.version}.jar \
      $out/share/java/commons-lang-${finalAttrs.version}.jar
    ln -s $out/share/java/commons-lang-${finalAttrs.version}.jar \
      $out/share/java/commons-lang.jar

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://commons.apache.org/proper/commons-lang/";
    description = "Apache Commons Lang provides extra functionality for classes in java.lang";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
