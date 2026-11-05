{
  ant,
  dom4j_14,
  fetchurl,
  jdk,
  jdom_10,
  stdenvNoCC,
  xml-apis_10,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jaxen";
  version = "1.1-beta-2";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/jaxen/jaxen/1.1-beta-2/jaxen-1.1-beta-2-src.tar.gz";
    hash = "sha256-R9KZ+IzH3wrt/WePUk3pwQKNcn3BrqHWY7zgyjjHaAU=";
  };

  nativeBuildInputs = [ant jdk];

  patches = [
    ./jaxen_11-beta-2_enum.patch
    ./jaxen_11-beta-2_dom3.patch
    # In JDOM 1.0 beta 8, getParent() returned an org.jdom.Element
    # We are compiling with JDOM 1.0 (final) because the beta 8 exists only as a binary.
    # This casts some getParent() calls to Element. Jaxen did the same fix in a later version.
    ./jaxen_11-beta-2_jdom-1.0.patch
    ./jaxen_11-beta-2_disable-tests.patch
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -pv target/lib
    cp ${dom4j_14}/share/java/*.jar target/lib/
    cp ${jdom_10}/share/java/*.jar target/lib/
    cp ${xml-apis_10}/share/java/*.jar target/lib/

    ant \
      -Dnoget \
      jar

    runHook postBuild
  '';

  javaRelease = 8;

  installPhase = ''
    runHook preInstall

    ln -s jaxen-${finalAttrs.version}.jar $out/share/java/jaxen.jar

    runHook postInstall
  '';
})
