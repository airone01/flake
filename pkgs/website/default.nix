# feature: Zola blog website package with devShells and NixOS modules
{
  ai-robots-txt,
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

  zolaTheme = zola-386.overrideAttrs (prev: {
    patches = (prev.patches or []) ++ [./0002-fix-index.html-main-blog-page.patch];
  });

  preBuild = ''
    mkdir -pv themes/zola.386

    cp -rv $zolaTheme/* themes/zola.386/

    mkdir -pv templates
    cp -v ${ai-robots-txt}/robots.txt templates/ai.robots.txt

    chmod -Rv +w themes/zola.386
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
