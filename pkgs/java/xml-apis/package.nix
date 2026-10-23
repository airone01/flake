{
  lib,
  fetchurl,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "xml-apis";
  version = "1.3.04";

  # No public git repository; sourced from Maven Central sources.jar.
  # fetchzip doesn't handle .jar extensions; extract manually with jar xf.
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/xml-apis/xml-apis/${finalAttrs.version}/xml-apis-${finalAttrs.version}-sources.jar";
    hash = "sha256-0xAhmlcn1UJMS3qFmRs8CCGI6kITOFHNL6wG+W2DN8o=";
  };

  unpackPhase = "true";

  buildPhase = ''
    runHook preBuild

    jar xf $src

    mkdir -p build/classes
    find . -name "*.java" ! -path "./META-INF/*" > sources.txt

    javac --release 8 -encoding UTF-8 -d build/classes @sources.txt

    jar cf xml-apis-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  meta = {
    description = "W3C DOM, SAX and JAXP API definitions";
    homepage = "https://xml.apache.org/commons/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
