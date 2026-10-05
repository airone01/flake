{
  lib,
  mkJavaPackage,
  fetchFromGitHub,
}:
# Pure-annotations library (nullness markers for static analysis), built with
# javac alone — no dependencies. jsoup compiles against these (provided scope
# upstream: needed at compile time, not bundled at runtime).
mkJavaPackage (finalAttrs: {
  pname = "jspecify";
  version = "0.3.0";

  # NullMarked targets ElementType.MODULE (Java 9+), so use -source/-target 8
  # (which keeps the full running-JDK API) rather than --release 8, whose
  # Java-8 API surface lacks ElementType.MODULE.
  javaRelease = null;
  javacFlags = [
    "-source"
    "8"
    "-target"
    "8"
  ];

  src = fetchFromGitHub {
    owner = "jspecify";
    repo = "jspecify";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kPeRTncvY5iIQQ4AOM6prOFxMRjvM8Dc8/wPuJFk5go=";
  };

  meta = {
    homepage = "https://jspecify.dev/";
    description = "Standard annotations for expressing nullness in Java for static analysis";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
