# feature: noctalia desktop shell package wrapper
{
  pkgs,
  lib ? pkgs.lib,
  niri ? pkgs.niri,
  noctalia ? pkgs.noctalia,
  ...
}: let
  # TODO: Use Noctalia v5 Niri color template @ assets/templates/niri/niri.kdl
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

  defaultConfigDir = pkgs.runCommand "noctalia-default-config" {} ''
    install -Dm 644 ${./config.toml} $out/noctalia/config.toml
  '';
in
  pkgs.symlinkJoin {
    name = "noctalia-${
      if lib.isNull noctalia.version
      then (lib.throw "`noctalia` package should have a version attr")
      else noctalia.version
    }";

    paths = [noctalia colorGenScript];

    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/noctalia \
        --run '
          # If user has no config of their own, fallback
          if [ -z "$NOCTALIA_CONFIG_HOME" ] && [ ! -d "''${XDG_CONFIG_HOME:-$HOME/.config}/noctalia"]; then
            export NOCTALIA_CONFIG_HOME="${defaultConfigDir}"
          fi
        ' \
        --prefix PATH : "/run/current-system/sw/bin:/etc/profiles/per-user/\$USER/bin:${lib.makeBinPath (with pkgs; [xdg-utils glib bash coreutils jq desktop-file-utils niri])}"
    '';

    passthru =
      (noctalia.passthru or {})
      // {
        inherit colorGenScript;
      };

    meta =
      (noctalia.meta or {})
      // {
        mainProgram = "noctalia";
      };
  }
