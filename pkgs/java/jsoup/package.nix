{
  lib,
  fetchFromGitHub,
  mkJavaPackage,
  jspecify,
}:
# Pure-Java HTML parser, built with javac. Its only compile-time dependency is
# jspecify (nullness annotations, provided scope upstream); not propagated, as
# it isn't needed at runtime. The src/main/java9 module-info is for the modular
# multi-release jar and is intentionally skipped in this plain build.
mkJavaPackage (finalAttrs: {
  pname = "jsoup";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "jhy";
    repo = "jsoup";
    rev = "jsoup-${finalAttrs.version}";
    hash = "sha256-Zkq2W9p8AAgeuWxze1QJfmmzwLPz4iNm6UggW5sZmJ0=";
  };

  classpath = [jspecify];

  meta = {
    homepage = "https://jsoup.org/";
    description = "Java HTML parser for real-world HTML: editing, cleaning, scraping, and XSS safety";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
