{
  fetchzip,
  installFonts,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mek-sans";
  version = "1.010";
  outputs = ["out" "webfont"];

  src = fetchzip {
    url = "https://mektxt.com/assets/downloads/fonts/MEKSans-${finalAttrs.version}.zip";
    hash = "sha256-lSQQ7qdWGw4SYg3ouWa/pILOIMk5UlVG6KUHwrVQcZg=";
  };

  nativeBuildInputs = [installFonts];

  meta = {
    description = "MEK.txt's MEK Sans typeface";
    homepage = "https://mektxt.com/fonts/meksans";
    maintainers = [lib.maintainers.airone01];
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
  };
})
