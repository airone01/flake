# feature: noctalia desktop shell package wrapper
{
  pkgs,
  lib ? pkgs.lib,
  niri ? pkgs.niri,
  ...
}: let
  colorGenScript = pkgs.writeShellScriptBin "noctalia-color-generation" ''
        CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}"
        COLORS_FILE="$CONFIG_DIR/noctalia/colors.json"
        BORDER_FILE="$CONFIG_DIR/niri/border.kdl"

        if [ -f "$COLORS_FILE" ]; then
            PRIMARY_COLOR=$(${pkgs.jq}/bin/jq -r '.mPrimary // "#fffd66"' "$COLORS_FILE")

            mkdir -p "$CONFIG_DIR/niri"

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
  baseParsed = builtins.fromJSON (builtins.replaceStrings ["/home/r1"] ["@HOME@"] rawSettings);

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
      sessionMenu =
        (settingsObj.sessionMenu or {})
        // {
          powerOptions = map (
            opt:
              if (opt.action or "") == "logout"
              then opt // {command = "niri msg action quit --skip-confirmation";}
              else opt
          ) (settingsObj.sessionMenu.powerOptions or []);
        };
    };

  parsed =
    if baseParsed ? settings
    then baseParsed // {settings = updatedSettings;}
    else updatedSettings;

  settingsTemplate = pkgs.writeText "noctalia-settings-template.json" (builtins.toJSON (parsed.settings or parsed));
in
  pkgs.symlinkJoin {
    name = "noctalia-shell-${pkgs.noctalia-shell.version or "4.7.7"}";
    paths = [pkgs.noctalia-shell colorGenScript];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/noctalia-shell \
        --run '
          if [ -z "$NOCTALIA_SETTINGS_FILE" ]; then
            _runtime_dir="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/noctalia"
            mkdir -p "$_runtime_dir"
            _settings_file="$_runtime_dir/settings.json"
            ${pkgs.gnused}/bin/sed "s|@HOME@|$HOME|g" "${settingsTemplate}" > "$_settings_file"
            export NOCTALIA_SETTINGS_FILE="$_settings_file"
          fi
        ' \
        --prefix PATH : "/run/current-system/sw/bin:/etc/profiles/per-user/\$USER/bin:${lib.makeBinPath (with pkgs; [xdg-utils glib bash coreutils jq desktop-file-utils niri])}"
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
