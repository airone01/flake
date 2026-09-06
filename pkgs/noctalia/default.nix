# feature: noctalia desktop shell package wrapper
{
  pkgs,
  homeDir ? "/home/r1",
  ...
}: let
  jsoncConf = builtins.readFile ./noctalia.jsonc;
  conf = pkgs.writeText "noctalia-settings.json" jsoncConf;
in
  pkgs.symlinkJoin {
    name = "noctalia-shell-${pkgs.noctalia-shell.version or "4.7.7"}";
    paths = [pkgs.noctalia-shell];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/noctalia-shell \
        --set NOCTALIA_SETTINGS_FILE "${conf}"
    '';
    postPatch = ''
      jq '.' ${conf} > ${conf} # strips comments from jsonc
      substituteInPlace ${conf} --replace-fail "@HOME" "${homeDir}"
      substituteInPlace ${conf} --replace-fail "@VERSION" "${pkgs.noctalia-shell.version}"
    '';
    meta =
      (pkgs.noctalia-shell.meta or {})
      // {
        mainProgram = "noctalia-shell";
      };
  }
