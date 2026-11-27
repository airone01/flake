{
  fetchzip,
  installFonts,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grout";
  version = "Alpha-v2";

  src = fetchzip {
    url = "https://mektxt.com/assets/downloads/fonts/GROUT-${finalAttrs.version}.zip";
    hash = "sha256-sfmwq4nvLkBI6n3XxeF3j4JnyDuI7EM/PFTwDJRSSvo=";
  };

  nativeBuildInputs = [installFonts];

  meta = {
    description = "MEK.txt's GROUT typeface";
    homepage = "https://mektxt.com/fonts/grout";
    maintainers = [lib.maintainers.airone01];
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
  };
})
