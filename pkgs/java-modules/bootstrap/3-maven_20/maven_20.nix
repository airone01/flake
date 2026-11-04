{
  ant,
  commons-cli_10,
  fetchurl,
  jdk_headless,
  makeWrapper,
  stdenvNoCC,
}: let
  mkMavenDep = {
    pkg,
    groupId ? pkg.pname,
    artifactId ? pkg.pname,
    version ? pkg.version,
  }: let
    groupPath = builtins.replaceStrings ["."] ["/"] groupId;
  in ''
    DIR="$REPO/${groupPath}/${artifactId}/${version}"
    mkdir -pv "$DIR"

    cp -v ${pkg}/share/java/${artifactId}-${version}.jar "$DIR/${artifactId}-${version}.jar"

    cat <<EOF > "$DIR/${artifactId}-${version}.pom"
    <project>
      <modelVersion>4.0.0</modelVersion>
      <groupId>${groupId}</groupId>
      <artifactId>${artifactId}</artifactId>
      <version>${version}</version>
    </project>
    EOF
  '';
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "maven";
    version = "2.0.11";

    src = fetchurl {
      url = "mirror://apache/maven/maven-2/${finalAttrs.version}/source/apache-maven-${finalAttrs.version}-src.tar.gz";
      hash = "sha256-p2WbFzBR6K2uRIK8J9XqdeJgZ/JsYXzJkWLzMuvtupc=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ant makeWrapper];

    buildPhase = ''
      runHook preBuild

      cd maven-${finalAttrs.version}-src

      export REPO="/build/.m2/repository"
      export M2_HOME="$out/share/maven/"
      mkdir -pv lib/ ''$M2_HOME

      ${mkMavenDep {
        pkg = commons-cli_10;
      }}

      # -Dskip.pull=true \
      ant \
        -Dmaven.repo.local="$REPO" \
        maven-assembly

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # makeWrapper $out/maven/bin/mvn $out/bin/mvn \
      #   --set-default JAVA_HOME "${jdk_headless}"
      # makeWrapper $out/maven/bin/mvnDebug $out/bin/mvnDebug \
      #   --set-default JAVA_HOME "${jdk_headless}"

      runHook postInstall
    '';
  })
