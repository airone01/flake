# feature: noctalia desktop shell package wrapper
{
  pkgs,
  mainUser ? "r1",
  ...
}: let
  homeDir = "/home/${mainUser}";
  rawSettings = builtins.readFile ./noctalia.json;
  # Patch hardcoded `/home/r1` path
  patchedSettings = builtins.replaceStrings ["/home/r1"] [homeDir] rawSettings;
  settingsFile = pkgs.writeText "noctalia-settings.json" patchedSettings;
in
  pkgs.symlinkJoin {
    name = "noctalia-shell-${pkgs.noctalia-shell.version or "4.7.7"}";
    paths = [pkgs.noctalia-shell];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/noctalia-shell \
        --set NOCTALIA_SETTINGS_FILE "${settingsFile}"
    '';
    meta =
      (pkgs.noctalia-shell.meta or {})
      // {
        mainProgram = "noctalia-shell";
      };
  }
