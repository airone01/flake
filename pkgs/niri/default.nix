{
  pkgs,
  lib,
  inputs,
  keyboardLayout ? "us,fr",
  noctalia ? null,
  ratePatch ? false,
  ...
}: let
  niri-highrr = pkgs.writeShellScriptBin "niri-highrr" ''
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
  '';
in
  inputs.wrapper-modules.wrappers.niri.wrap {
    inherit pkgs;

    settings =
      {
        prefer-no-csd = {};
        spawn-at-startup =
          lib.optionals (noctalia != null) [[(lib.getExe noctalia)]]
          ++ lib.optionals ratePatch [[(lib.getExe niri-highrr)]];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        input.keyboard.xkb.layout = keyboardLayout;
        input.touchpad.tap = {};
      }
      // lib.optionalAttrs ratePatch {
        outputs.".*".variable-refresh-rate = {};
      }
      // {
        binds =
          {
            "Mod+Return".spawn = lib.getExe pkgs.kitty;
            "Mod+Q".close-window = {};
            "Mod+S".spawn-sh =
              if noctalia != null
              then "${lib.getExe noctalia} ipc call launcher toggle"
              else "${lib.getExe pkgs.rofi} -show drun";

            "Mod+E".spawn = lib.getExe pkgs.thunar;
            "Mod+R".spawn = ["${lib.getExe pkgs.kitty}" "-e" "${lib.getExe pkgs.yazi}"];
            "Mod+Shift+B".spawn = lib.getExe pkgs.firefox;
            "Mod+V".spawn-sh = "${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.rofi} -dmenu | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy";
            "Print".spawn = ["${lib.getExe pkgs.grimblast}" "copy" "area"];

            "Mod+F".maximize-column = {};
            "Mod+Shift+F".fullscreen-window = {};
            "Mod+C".center-column = {};
            "Mod+P".toggle-window-floating = {};

            "Mod+Left".focus-column-left = {};
            "Mod+Right".focus-column-right = {};
            "Mod+Up".focus-window-up = {};
            "Mod+Down".focus-window-down = {};

            "Mod+Shift+Left".move-column-left = {};
            "Mod+Shift+Right".move-column-right = {};
            "Mod+Shift+Up".move-window-up = {};
            "Mod+Shift+Down".move-window-down = {};

            "Mod+Ctrl+Left".set-column-width = "-10%";
            "Mod+Ctrl+Right".set-column-width = "+10%";
            "Mod+Ctrl+Up".set-window-height = "-10%";
            "Mod+Ctrl+Down".set-window-height = "+10%";

            "Mod+Shift+Ctrl+Left".move-window-to-monitor-left = {};
            "Mod+Shift+Ctrl+Right".move-window-to-monitor-right = {};

            "XF86AudioRaiseVolume".spawn = ["${lib.getExe pkgs.pamixer}" "-i" "5"];
            "XF86AudioLowerVolume".spawn = ["${lib.getExe pkgs.pamixer}" "-d" "5"];
            "XF86AudioMute".spawn = ["${lib.getExe pkgs.pamixer}" "-t"];
            "XF86MonBrightnessUp".spawn = ["${lib.getExe pkgs.brightnessctl}" "s" "10%+"];
            "XF86MonBrightnessDown".spawn = ["${lib.getExe pkgs.brightnessctl}" "s" "10%-"];
            "XF86AudioPlay".spawn = ["${lib.getExe pkgs.playerctl}" "play-pause"];
            "XF86AudioNext".spawn = ["${lib.getExe pkgs.playerctl}" "next"];
            "XF86AudioPrev".spawn = ["${lib.getExe pkgs.playerctl}" "previous"];
          }
          // lib.optionalAttrs (noctalia != null) {
            "Mod+L".spawn-sh = "${lib.getExe noctalia} ipc call lockScreen lock";
          }
          // (builtins.listToAttrs (builtins.concatLists (builtins.genList (x: let
            ws = x + 1;
            num = toString (
              if x == 9
              then 0
              else x + 1
            );
            azertySyms = ["ampersand" "eacute" "quotedbl" "apostrophe" "parenleft" "minus" "egrave" "underscore" "ccedilla" "agrave"];
            sym = builtins.elemAt azertySyms x;
            isFr = lib.hasInfix "fr" keyboardLayout;
          in
            if isFr
            then [
              {
                name = "Mod+${sym}";
                value.focus-workspace = ws;
              }
              {
                name = "Mod+Shift+${sym}";
                value.move-column-to-workspace = ws;
              }
              {
                name = "Mod+${num}";
                value.focus-workspace = ws;
              }
              {
                name = "Mod+Shift+${num}";
                value.move-column-to-workspace = ws;
              }
            ]
            else [
              {
                name = "Mod+${num}";
                value.focus-workspace = ws;
              }
              {
                name = "Mod+Shift+${num}";
                value.move-column-to-workspace = ws;
              }
            ])
          10)));
      };
  }
