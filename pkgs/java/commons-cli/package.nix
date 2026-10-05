{
  lib,
  mkJavaPackage,
  fetchFromGitHub,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-cli";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-cli";
    rev = "rel/commons-cli-${finalAttrs.version}";
    hash = "sha256-xYefS5iict9yspWEZrhgGfWbqT9uzfilj3ehXjgQBOE=";
  };

  meta = {
    homepage = "https://commons.apache.org/proper/commons-cli/";
    description = "Apache Commons CLI provides a simple API for presenting, processing and validating a command line interface";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
