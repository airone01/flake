{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdk,
  stripJavaArchivesHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "commons-io";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-io";
    rev = "rel/commons-io-${finalAttrs.version}";
    hash = "sha256-fzfrmR0LhFihXe0TdEO3M4EIR0MxJw0AwhiSWRC6PVs=";
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

    jar cf commons-io-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 commons-io-${finalAttrs.version}.jar \
      $out/share/java/commons-io-${finalAttrs.version}.jar
    ln -s $out/share/java/commons-io-${finalAttrs.version}.jar \
      $out/share/java/commons-io.jar

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://commons.apache.org/proper/commons-io/";
    description = "Apache Commons IO is a library of utilities to assist with developing IO functionality";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
