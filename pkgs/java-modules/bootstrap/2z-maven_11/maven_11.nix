{
  ant,
  commons-logging,
  fetchurl,
  lib,
  log4j_12,
  replaceVars,
  stdenvNoCC,
}: let
  repoDir = "/build/.m2/repository";

  concatDepInstall = lib.lists.foldr (a: b:
    ''
      install -Dm 644 \
        "${a}/share/java/${a.pname}-${a.version}.jar" \
        "${repoDir}/${a.pname}/jars/${a.pname}-${a.version}.jar"
    ''
    + b) "";
  installDeps = concatDepInstall [
    commons-logging
    log4j_12
  ];
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "maven";
    version = "1.1";

    src = fetchurl {
      url = "mirror://apache/maven/maven-1/${finalAttrs.version}/source/maven-${finalAttrs.version}-src.tar.gz";
      hash = "sha256-PTBtbLTQ+XntEQNg6jAI70o4qu6efBzbjf9NHSQQ+F4=";
    };

    nativeBuildInputs = [ant];

    patches = [
      (replaceVars ./0001-maven-build-offline.patch {
        repository = repoDir;
      })
    ];

    buildPhase = ''
      runHook preBuild

      export MAVEN_HOME="/build/maven-home"
      export REPO="/build/.m2/repository"
      mkdir -pv ''$MAVEN_HOME ''$REPO

      ${installDeps}
      ls -Rlah "${repoDir}"

      ant \
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
