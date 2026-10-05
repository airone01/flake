{
  lib,
  mkJavaPackage,
  fetchFromGitHub,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-lang3";
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-lang";
    rev = "rel/commons-lang-${finalAttrs.version}";
    hash = "sha256-RB9PCDTCd8iAWOibrR9zL0xE6OMTmiJY0ZgLqgxBe2Q=";
  };

  meta = {
    homepage = "https://commons.apache.org/proper/commons-lang/";
    description = "Apache Commons Lang3 provides extra functionality for classes in java.lang";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
