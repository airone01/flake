# feature: noctalia desktop shell package wrapper
{
  pkgs,
  inputs ? {},
  mainUser ? "r1",
  ...
}: let
  homeDir = "/home/${mainUser}";
  rawSettings = builtins.readFile ./noctalia.json;
  parsed = builtins.fromJSON (builtins.replaceStrings ["/home/r1"] [homeDir] rawSettings);
  settingsJson = builtins.toJSON (parsed.settings or parsed);
in
  if inputs ? wrapper-modules
  then
    inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      inherit (parsed) settings;
      extraPackages = with pkgs; [
        xdg-utils
        glib
        bash
        coreutils
      ];
    }
  else
    pkgs.symlinkJoin {
      name = "noctalia-shell-${pkgs.noctalia-shell.version or "4.7.7"}";
      paths = [pkgs.noctalia-shell];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/noctalia-shell \
          --set NOCTALIA_SETTINGS_FILE "${pkgs.writeText "noctalia-settings.json" settingsJson}"
      '';
      meta =
        (pkgs.noctalia-shell.meta or {})
        // {
          mainProgram = "noctalia-shell";
        };
    }
