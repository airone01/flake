# Helper to build pure Java packages from source using javac.
# This finds sources, compiles with javac, makes a jar, and installs for packages that don't required a build tool.
{
  lib,
  stdenvNoCC,
  jdk,
  stripJavaArchivesHook,
}: fnOrAttrs:
stdenvNoCC.mkDerivation (finalAttrs: let
  attrs =
    if lib.isFunction fnOrAttrs
    then fnOrAttrs finalAttrs
    else fnOrAttrs;

  javaRelease = attrs.javaRelease or 8;
  encoding = attrs.encoding or "UTF-8";
  javaSourceDir = attrs.javaSourceDir or "src/main/java";
  excludeSourcePatterns = attrs.excludeSourcePatterns or [];
  resourcesDir = attrs.resourcesDir or "src/main/resources";
  classpath = attrs.classpath or [];
  extraClasspath = attrs.extraClasspath or "";
  jarName = attrs.jarName or attrs.pname;
  javacFlags = attrs.javacFlags or [];

  defaultBuildPhase = ''
    runHook preBuild

    mkdir -p build/classes

    find ${javaSourceDir} -name "*.java" \
      ${lib.concatMapStrings (pat: "! -path '${pat}' ") excludeSourcePatterns} \
      > sources.txt

    build_cp=""
    ${lib.concatMapStringsSep "\n" (dep: ''
        if [ -d "${dep}/share/java" ]; then
          for j in "${dep}/share/java"/*.jar; do
            [ -e "$j" ] || continue
            if [ -L "$j" ] && [ -e "$(readlink -f "$j")" ]; then
              continue
            fi
            build_cp="''${build_cp:+$build_cp:}$j"
          done
        fi
      '')
      classpath}
    if [ -n "${extraClasspath}" ]; then
      build_cp="''${build_cp:+$build_cp:}${extraClasspath}"
    fi

    cp_arg=""
    if [ -n "$build_cp" ]; then
      cp_arg="-classpath $build_cp"
    fi

    javac \
      --release ${toString javaRelease} \
      -encoding ${encoding} \
      $cp_arg \
      ${lib.escapeShellArgs javacFlags} \
      -d build/classes \
      @sources.txt

    if [ -n "${resourcesDir}" ] && [ -d "${resourcesDir}" ]; then
      cp -r ${resourcesDir}/. build/classes/ 2>/dev/null || true
    fi

    jar cf ${jarName}-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  defaultInstallPhase = ''
    runHook preInstall

    install -Dm644 ${jarName}-${finalAttrs.version}.jar \
      $out/share/java/${jarName}-${finalAttrs.version}.jar
    ln -s ${jarName}-${finalAttrs.version}.jar \
      $out/share/java/${jarName}.jar

    runHook postInstall
  '';

  cleanedAttrs = builtins.removeAttrs attrs [
    "javaRelease"
    "encoding"
    "javaSourceDir"
    "excludeSourcePatterns"
    "resourcesDir"
    "classpath"
    "extraClasspath"
    "jarName"
    "javacFlags"
  ];
in
  cleanedAttrs
  // {
    __structuredAttrs = attrs.__structuredAttrs or true;
    strictDeps = attrs.strictDeps or true;

    nativeBuildInputs =
      [
        jdk
        stripJavaArchivesHook
      ]
      ++ (attrs.nativeBuildInputs or []);

    buildPhase = attrs.buildPhase or defaultBuildPhase;
    installPhase = attrs.installPhase or defaultInstallPhase;

    meta =
      {
        platforms = lib.platforms.all;
        sourceProvenance = with lib.sourceTypes; [fromSource];
      }
      // (attrs.meta or {});
  })
