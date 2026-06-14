{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdk,
  stripJavaArchivesHook,
  xml-apis,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xercesImpl";
  version = "2.9.1";

  # Xerces-J 2.9.0 (the version bundled in ant_1_7) has no source tarball.
  # 2.9.1 is the next point release; API-compatible and available on GitHub.
  src = fetchFromGitHub {
    owner = "apache";
    repo = "xerces2-j";
    rev = "Xerces-J_${lib.replaceStrings ["."] ["_"] finalAttrs.version}";
    hash = "sha256-uhtVwm8SCSyEkUo9uTM07x+BrMqSSZP42GBMFLM8VF4=";
  };

  nativeBuildInputs = [
    jdk
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p build/classes

    # XMLCatalogResolver uses the optional xml-resolver package; exclude it.
    find src -name "*.java" \
      ! -path "*/xerces/util/XMLCatalogResolver.java" \
      > sources.txt

    javac --release 8 -encoding UTF-8 \
      -classpath "${xml-apis}/share/java/xml-apis.jar" \
      -d build/classes \
      @sources.txt

    # Bundle non-Java resources (message bundles, .properties, .res files)
    find src -not -name "*.java" -type f | while read f; do
      rel="''${f#src/}"
      mkdir -p "build/classes/''${rel%/*}"
      cp "$f" "build/classes/$rel"
    done

    jar cf xercesImpl-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 xercesImpl-${finalAttrs.version}.jar \
      $out/share/java/xercesImpl-${finalAttrs.version}.jar
    ln -s $out/share/java/xercesImpl-${finalAttrs.version}.jar \
      $out/share/java/xercesImpl.jar

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Apache Xerces-J XML parser";
    homepage = "https://xerces.apache.org/xerces2-j/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
