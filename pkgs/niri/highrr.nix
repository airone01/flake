# feature: niri high refresh rate monitor switcher script
{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellScriptBin "niri-highrr" ''
  log() { ${pkgs.util-linux}/bin/logger -t niri-highrr "$*"; }

  apply_highrr() {
    local cmd
    cmd=$(niri msg --json outputs | ${lib.getExe pkgs.jq} -r '.[] | . as $out | ($out.modes | sort_by(.refresh_rate) | last) as $max | "niri msg output \"\($out.name)\" mode \($max.width)x\($max.height)@\($max.refresh_rate / 1000)"')
    log "running: $cmd"
    echo "$cmd" | bash 2>&1 | log "result:"
    log "current_mode after: $(niri msg --json outputs | ${lib.getExe pkgs.jq} '.[].current_mode')"
  }

  until niri msg version &>/dev/null; do
    sleep 0.5
  done
  log "IPC ready"

  apply_highrr

  niri msg --json event-stream | while read -r line; do
    if echo "$line" | ${pkgs.gnugrep}/bin/grep -q 'OutputsChanged'; then
      log "OutputsChanged event"
      apply_highrr
    fi
  done
''
