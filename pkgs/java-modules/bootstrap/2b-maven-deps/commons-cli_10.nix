{
  ant,
  commons-lang_10,
  fetchurl,
  jdk,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "commons-cli";
  version = "1.0";
  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://apache/commons/cli/source/cli-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-+kvwhQyJap1WefMNmSGpiz0mJngBlDPzbvgQI1rljsg=";
  };

  nativeBuildInputs = [ant jdk];

  buildPhase = ''
    runHook preBuild

    mkdir -pv lib/
    cp ${commons-lang_10}/share/java/*.jar lib/

    ant \
      -Dskip.pull=true \
      jar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 target/commons-cli-1.0-beta-2-dev.jar $out/share/java/commons-cli-${finalAttrs.version}.jar
    ln -s commons-cli-${finalAttrs.version}.jar $out/share/java/commons-lang.jar

    runHook postInstall
  '';
})
