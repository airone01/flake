{
  lib,
  buildNpmPackage,
  ...
}:
buildNpmPackage {
  pname = "astro-website";
  version = "0.1.0";
  src = ./website;

  npmDepsHash = "sha256-/bEQjF49dhanUnWMxp0jBSI4DPzn+ODazVraU7Cwugo=";

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dist/* $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "An Astro Website";
    homepage = "https://air1.one";
    license = licenses.mit;
    maintainers = [];
  };
}
