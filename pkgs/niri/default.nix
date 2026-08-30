{
  pkgs,
  lib,
  keyboardLayout ? "us,fr",
  noctalia ? null,
  ratePatch ? false,
  ...
}: let
  niri-highrr = pkgs.callPackage ./highrr.nix {};

  noctaliaBin =
    if noctalia != null
    then "${lib.getExe noctalia}"
    else null;

  highrrBin =
    if ratePatch
    then "${lib.getExe niri-highrr}"
    else null;

  configKdl = ''
    prefer-no-csd

    input {
        keyboard {
            xkb {
                layout "${keyboardLayout}"
            }
        }
        touchpad {
            tap
        }
    }

    xwayland-satellite {
        path "xwayland-satellite"
    }

    ${lib.optionalString ratePatch ''
      output ".*" {
          variable-refresh-rate
      }
    ''}

    ${lib.optionalString (noctaliaBin != null) ''spawn-at-startup "${noctaliaBin}"''}
    ${lib.optionalString (highrrBin != null) ''spawn-at-startup "${highrrBin}"''}

    binds {
        Mod+Return { spawn "kitty"; }
        Mod+Q { close-window; }
        Mod+S { spawn-sh "${
      if noctaliaBin != null
      then "${noctaliaBin} ipc call launcher toggle"
      else "rofi -show drun"
    }"; }
        Mod+E { spawn "thunar"; }
        Mod+R { spawn "kitty" "-e" "yazi"; }
        Mod+Shift+B { spawn "firefox"; }
        Mod+V { spawn-sh "cliphist list | rofi -dmenu | cliphist decode | wl-copy"; }
        Print { spawn "grimblast" "copy" "area"; }

        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }
        Mod+P { toggle-window-floating; }

        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up { focus-window-up; }
        Mod+Down { focus-window-down; }

        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up { move-window-up; }
        Mod+Shift+Down { move-window-down; }

        Mod+Ctrl+Left { set-column-width "-10%"; }
        Mod+Ctrl+Right { set-column-width "+10%"; }
        Mod+Ctrl+Up { set-window-height "-10%"; }
        Mod+Ctrl+Down { set-window-height "+10%"; }

        Mod+Shift+Ctrl+Left { move-window-to-monitor-left; }
        Mod+Shift+Ctrl+Right { move-window-to-monitor-right; }

        XF86AudioRaiseVolume { spawn "pamixer" "-i" "5"; }
        XF86AudioLowerVolume { spawn "pamixer" "-d" "5"; }
        XF86AudioMute { spawn "pamixer" "-t"; }
        XF86MonBrightnessUp { spawn "brightnessctl" "s" "10%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "s" "10%-"; }
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }

        ${lib.optionalString (noctaliaBin != null) ''Mod+L { spawn-sh "${noctaliaBin} ipc call lockScreen lock"; }''}

        ${
      if lib.hasInfix "fr" keyboardLayout
      then ''
        Mod+ampersand { focus-workspace 1; }
        Mod+eacute { focus-workspace 2; }
        Mod+quotedbl { focus-workspace 3; }
        Mod+apostrophe { focus-workspace 4; }
        Mod+parenleft { focus-workspace 5; }
        Mod+minus { focus-workspace 6; }
        Mod+egrave { focus-workspace 7; }
        Mod+underscore { focus-workspace 8; }
        Mod+ccedilla { focus-workspace 9; }
        Mod+agrave { focus-workspace 10; }

        Mod+Shift+ampersand { move-column-to-workspace 1; }
        Mod+Shift+eacute { move-column-to-workspace 2; }
        Mod+Shift+quotedbl { move-column-to-workspace 3; }
        Mod+Shift+apostrophe { move-column-to-workspace 4; }
        Mod+Shift+parenleft { move-column-to-workspace 5; }
        Mod+Shift+minus { move-column-to-workspace 6; }
        Mod+Shift+egrave { move-column-to-workspace 7; }
        Mod+Shift+underscore { move-column-to-workspace 8; }
        Mod+Shift+ccedilla { move-column-to-workspace 9; }
        Mod+Shift+agrave { move-column-to-workspace 10; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+0 { focus-workspace 10; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+Shift+0 { move-column-to-workspace 10; }
      ''
      else ''
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+0 { focus-workspace 10; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+Shift+0 { move-column-to-workspace 10; }
      ''
    }
    }
  '';

  configFile = pkgs.writeText "niri-config.kdl" configKdl;
in
  pkgs.symlinkJoin {
    name = "niri-${pkgs.niri.version}";
    paths = [pkgs.niri];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/niri \
        --add-flags "--config ${configFile}"
    '';
    passthru =
      (pkgs.niri.passthru or {})
      // {
        providedSessions = ["niri"];
      };
  }
