{
  ant,
  dom4j_15,
  fetchurl,
  jdk,
  jdom_10,
  stdenvNoCC,
  # Xerces 2.6.2's sources are not available
  xerces_281,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jaxen";
  version = "1.1-beta-6";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/jaxen/jaxen/1.1-beta-6/jaxen-1.1-beta-6-src.tar.gz";
    hash = "sha256-7U5ol8DsxVnRp3aYmenPwNNtL/1/ohf29W7bL9DAD6c=";
  };

  nativeBuildInputs = [ant jdk];

  patches = [
    ./jaxen_11-beta-2_dom3.patch
    ./jaxen_11-beta-4_disable-tests.patch
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -pv target/lib
    cp ${dom4j_15}/share/java/*.jar target/lib/
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
