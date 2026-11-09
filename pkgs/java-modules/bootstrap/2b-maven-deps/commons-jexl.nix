{
  ant,
  commons-logging,
  fetchurl,
  jdk,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "commons-jexl";
  version = "1.0";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/commons-jexl/commons-jexl/${finalAttrs.version}/commons-jexl-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-nhA24fMzrx9MBl+rsUcg1nHCDYZ+aJ3UVL3hgb47yt4=";
  };

  patches = [
    ./0001-commons-jexl-enum.patch
    ./0002-commons-jexl-disable-tests.patch
    ./0003-commons-jexl-out-version.patch
  ];

  nativeBuildInputs = [ant jdk];

  buildPhase = ''
    runHook preBuild

    mkdir -pv target/lib
    cp ${commons-logging}/share/java/*.jar target/lib/

    ant \
      -Dnoget \
      jar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 644 target/commons-jexl-${finalAttrs.version}.jar $out/share/java/commons-jexl-${finalAttrs.version}.jar
    ln -s $out/share/java/commons-jexl-${finalAttrs.version}.jar $out/share/java/commons-jexl.jar

    runHook postInstall
  '';
})
