{
  pkgs,
  zolaWebsite,
  ...
}:
pkgs.mkShell {
  inputsFrom = [zolaWebsite];

  shellHook = ''
    cd web
    ${zolaWebsite.preBuild}
  '';
}
