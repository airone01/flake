{
  ant,
  fetchurl,
  # log4j_12,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "maven";
  version = "1.1";

  src = fetchurl {
    url = "mirror://apache/maven/maven-1/${finalAttrs.version}/source/maven-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-PTBtbLTQ+XntEQNg6jAI70o4qu6efBzbjf9NHSQQ+F4=";
  };

  nativeBuildInputs = [ant];

  patches = [./0001-Enable-offline-mode-Maven-build.patch];

  # cp \
  #   ${log4j_12}/share/java/*.jar \
  #   ''$REPO
  buildPhase = ''
    runHook preBuild

    export MAVEN_HOME="/build/maven-home"
    export REPO="/build/.m2/repository"
    mkdir -pv ''$MAVEN_HOME ''$REPO

    ant \
      -Dmaven.repo.local="$REPO" \
      -Dant.build.javac.source=8 \
      -Dant.build.javac.target=8 \
      -f build-bootstrap.xml

    runHook postBuild
  '';

  installPhase = ''
    ls -lah
    exit 1

    mkdir -pv $out
  '';
})
