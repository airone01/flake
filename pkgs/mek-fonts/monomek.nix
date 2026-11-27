{
  fetchzip,
  installFonts,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "monomek";
  version = "1.204";

  src = fetchzip {
    url = "https://mektxt.com/assets/downloads/fonts/MonoMEK-${finalAttrs.version}.zip";
    hash = "sha256-gScneZyyz4BoQYSFgCXJ5x3MpNKwqQb/R+k+gQ9QEnk=";
  };

  nativeBuildInputs = [installFonts];

  meta = {
    description = "MEK.txt's MonoMEK typeface";
    homepage = "https://mektxt.com/fonts/monomek";
    maintainers = [lib.maintainers.airone01];
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
  };
})
