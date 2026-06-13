{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdk,
  stripJavaArchivesHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "commons-cli";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-cli";
    rev = "rel/commons-cli-${finalAttrs.version}";
    hash = "sha256-xYefS5iict9yspWEZrhgGfWbqT9uzfilj3ehXjgQBOE=";
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

    jar cf commons-cli-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 commons-cli-${finalAttrs.version}.jar \
      $out/share/java/commons-cli-${finalAttrs.version}.jar
    ln -s $out/share/java/commons-cli-${finalAttrs.version}.jar \
      $out/share/java/commons-cli.jar

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://commons.apache.org/proper/commons-cli/";
    description = "Apache Commons CLI provides a simple API for presenting, processing and validating a command line interface";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
