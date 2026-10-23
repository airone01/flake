{
  lib,
  mkJavaPackage,
  fetchFromGitHub,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-io";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-io";
    rev = "rel/commons-io-${finalAttrs.version}";
    hash = "sha256-fzfrmR0LhFihXe0TdEO3M4EIR0MxJw0AwhiSWRC6PVs=";
  };

  meta = {
    homepage = "https://commons.apache.org/proper/commons-io/";
    description = "Apache Commons IO is a library of utilities to assist with developing IO functionality";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
