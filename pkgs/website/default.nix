# feature: Zola blog website package with devShells and NixOS modules
{
  lib,
  pkgs,
  zola-386,
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "zola-website";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [pkgs.zola];

  zolaTheme = zola-386;

  preBuild = ''
    mkdir -p themes/zola.386

    cp -r ${zola-386}/* themes/zola.386/

    chmod -R +w themes/zola.386
  '';

  buildPhase = ''
    runHook preBuild

    SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" \
      zola build -o $out

    runHook postBuild
  '';

  meta = with lib; {
    description = "Retro Zola blog";
    homepage = "https://air1.one";
    license = licenses.mit;
  };
}
