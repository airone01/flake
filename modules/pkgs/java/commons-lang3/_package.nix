{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdk,
  stripJavaArchivesHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "commons-lang3";
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-lang";
    rev = "rel/commons-lang-${finalAttrs.version}";
    hash = "sha256-RB9PCDTCd8iAWOibrR9zL0xE6OMTmiJY0ZgLqgxBe2Q=";
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
      -d build/classes \
      @sources.txt

    jar cf commons-lang3-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 commons-lang3-${finalAttrs.version}.jar \
      $out/share/java/commons-lang3-${finalAttrs.version}.jar
    ln -s $out/share/java/commons-lang3-${finalAttrs.version}.jar \
      $out/share/java/commons-lang3.jar

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://commons.apache.org/proper/commons-lang/";
    description = "Apache Commons Lang3 provides extra functionality for classes in java.lang";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
