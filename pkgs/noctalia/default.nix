# feature: noctalia desktop shell package wrapper
{
  pkgs,
  lib,
  ...
}: let
  rawJsonc = builtins.readFile ./noctalia.jsonc;
  # Replace @VERSION placeholder if present
  versionPatched = builtins.replaceStrings ["@VERSION"] [pkgs.noctalia-shell.version or "4.7.7"] rawJsonc;
  defaultsFile = pkgs.writeText "noctalia-defaults.jsonc" versionPatched;

  wrapperScript = pkgs.writeShellScriptBin "noctalia-shell" ''
    set -euo pipefail

    CONFIG_DIR="$HOME/.config/noctalia"
    TARGET_CONF="$CONFIG_DIR/settings.json"
    DEFAULTS_SRC="${defaultsFile}"

    mkdir -p "$CONFIG_DIR"

    PROCESSED_DEFAULTS=$(mktemp)
    trap 'rm -f "$PROCESSED_DEFAULTS"' EXIT

    ${lib.getExe pkgs.jq} '.' "$DEFAULTS_SRC" | ${pkgs.gnused}/bin/sed "s|@HOME|$HOME|g" > "$PROCESSED_DEFAULTS"

    if [ -f "$TARGET_CONF" ]; then
      MERGED=$(mktemp)
      ${lib.getExe pkgs.jq} -s '.[0] * .[1]' "$PROCESSED_DEFAULTS" "$TARGET_CONF" > "$MERGED"
      mv "$MERGED" "$TARGET_CONF"
    else
      cp "$PROCESSED_DEFAULTS" "$TARGET_CONF"
    fi

    export NOCTALIA_SETTINGS_FILE="$TARGET_CONF"
    exec ${pkgs.noctalia-shell}/bin/noctalia-shell "$@"
  '';
in
  pkgs.symlinkJoin {
    name = "noctalia-shell-${pkgs.noctalia-shell.version or "4.7.7"}";
    paths = [wrapperScript pkgs.noctalia-shell];
    meta =
      (pkgs.noctalia-shell.meta or {})
      // {
        mainProgram = "noctalia-shell";
      };
  }
