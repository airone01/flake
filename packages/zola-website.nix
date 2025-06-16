{
  pkgs,
  lib,
}:
pkgs.stdenv.mkDerivation {
  pname = "zola-website";
  version = "1.0.0";
  src = ../web;
  nativeBuildInputs = [pkgs.zola];

  buildPhase = "zola build";
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
