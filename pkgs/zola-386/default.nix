{
  lib,
  pkgs,
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "zola.386";
  version = "unstable-04-24-2022";

  src = pkgs.fetchFromGitHub {
    owner = "lopes";
    repo = "zola.386";
    rev = "d9c9726435d1347341f2171f9aa751291f1db93d";
    hash = "sha256-pmlgG7cS7daJek8U+Epb1Flo4mOESyudiAQDv9YyHRQ=";
  };

  patches = [
    ./0001-fix-update-macro-syntax-for-zola-0.23.x.patch
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -pv $out
    cp -r * $out

    runHook postBuild;
  '';

  meta = with lib; {
    description = "Port of BOOTSTRA.386 for Zola.";
    homepage = "https://github.com/lopes/zola.386";
    license = licenses.mit;
  };
}
