{
  pkgs,
  lib,
  anemone-theme,
}:
pkgs.stdenv.mkDerivation {
  pname = "zola-website";
  version = "1.0.0";
  src = ../web;
  nativeBuildInputs = [pkgs.zola];

  preBuild = ''
    mkdir -p themes
    rm -rf themes/anemone
    ln -s ${anemone-theme} themes/anemone
  '';

  buildPhase = ''
    runHook preBuild
    zola build
  '';
  installPhase = ''
    mkdir -p $out
    cp -r public/* $out/
  '';

  meta = with lib; {
    description = "Static website built with Zola";
    homepage = "https://air1.one/";
    license = licenses.mit;
    maintainers = [];
  };
}
