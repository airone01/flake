# feature: noctalia desktop shell package wrapper
{
  pkgs,
  inputs ? {},
  mainUser ? "r1",
  ...
}: let
  homeDir = "/home/${mainUser}";

  colorGenScript = pkgs.writeShellScriptBin "noctalia-color-generation" ''
        COLORS_FILE="${homeDir}/.config/noctalia/colors.json"
        BORDER_FILE="${homeDir}/.config/niri/border.kdl"

        if [ -f "$COLORS_FILE" ]; then
            PRIMARY_COLOR=$(${pkgs.jq}/bin/jq -r '.mPrimary // "#fffd66"' "$COLORS_FILE")

            mkdir -p "${homeDir}/.config/niri"

            cat <<EOF > "$BORDER_FILE"
    layout {
        border {
            active-color "$PRIMARY_COLOR"
        }
    }
    EOF

            if ${pkgs.procps}/bin/pgrep -x niri >/dev/null && command -v niri &>/dev/null; then
                niri msg action load-config-file
            fi
        fi
  '';

  rawSettings = builtins.readFile ./noctalia.json;
  baseParsed = builtins.fromJSON (builtins.replaceStrings ["/home/r1"] [homeDir] rawSettings);

  settingsObj = baseParsed.settings or baseParsed;
  updatedSettings =
    settingsObj
    // {
      hooks =
        (settingsObj.hooks or {})
        // {
          enabled = true;
          colorGeneration = "${colorGenScript}/bin/noctalia-color-generation";
        };
    };

  parsed =
    if baseParsed ? settings
    then baseParsed // {settings = updatedSettings;}
    else updatedSettings;

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
        jq
        colorGenScript
      ];
    }
  else
    pkgs.symlinkJoin {
      name = "noctalia-shell-${pkgs.noctalia-shell.version or "4.7.7"}";
      paths = [pkgs.noctalia-shell colorGenScript];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/noctalia-shell \
          --set NOCTALIA_SETTINGS_FILE "${pkgs.writeText "noctalia-settings.json" settingsJson}"
      '';
      passthru =
        (pkgs.noctalia-shell.passthru or {})
        // {
          inherit colorGenScript;
        };
      meta =
        (pkgs.noctalia-shell.meta or {})
        // {
          mainProgram = "noctalia-shell";
        };
    }
