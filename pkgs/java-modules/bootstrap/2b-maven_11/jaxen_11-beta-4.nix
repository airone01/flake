{
  ant,
  # Dom4J 1.5.2 is required, butit's a cyclic dep,
  # so using the last version that I could find sources of
  dom4j_14,
  fetchurl,
  jdk,
  jdom_10,
  stdenvNoCC,
  # Xerces 2.6.2's sources are not available
  xerces_281,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jaxen";
  version = "1.1-beta-4";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/jaxen/jaxen/1.1-beta-4/jaxen-1.1-beta-4-src.tar.gz";
    hash = "sha256-lVDg55xn2YwlXlTCACgixZcjrzhXSiCcGB5S85SmGOw=";
  };

  nativeBuildInputs = [ant jdk];

  patches = [
    ./jaxen_11-beta-2_dom3.patch
    ./jaxen_11-beta-4_disable-tests.patch
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -pv target/lib
    cp ${dom4j_14}/share/java/*.jar target/lib/
    cp ${jdom_10}/share/java/*.jar target/lib/
    cp ${xerces_281}/share/java/*.jar target/lib/

    # XOM does not expose its sources before 1.1, which is built with a later Jaxen.
    # Skipping, will add for later Jaxen versions.
    rm -rf src/java/main/org/jaxen/xom

    ant \
      -Dnoget \
      jar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/java
    install -m644 target/jaxen-${finalAttrs.version}.jar $out/share/java/jaxen-${finalAttrs.version}.jar
    ln -s $out/share/java/jaxen-${finalAttrs.version}.jar $out/share/java/jaxen.jar

    runHook postInstall
  '';
})
