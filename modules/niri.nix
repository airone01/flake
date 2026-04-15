{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {
    lib,
    pkgs,
    config,
    ...
  }: let
    # What 'niri-highrr' does:
    # - Queries Niri's IPC on startup (niri msg --json outputs) to detect all
    #   connected monitors.
    # - Uses jq to parse out all available modes for each monitor and
    #   automatically selects the one with the highest refresh rate.
    # - Dynamically issues the correct niri msg output <name> mode <WxH@Hz>
    #   command to apply it instantly.
    # - Listens to Niri's event stream in the background for OutputsChanged
    #   events, so if you plug in a new high refresh rate monitor later, it will
    #   instantly bump it to the maximum refresh rate automatically!
    niri-highrr = pkgs.writeShellScriptBin "niri-highrr" ''
      apply_highrr() {
        niri msg --json outputs | ${lib.getExe pkgs.jq} -r '.[] | . as $out | ($out.modes | sort_by(.refresh_rate) | last) as $max | "niri msg output \"\($out.name)\" mode \($max.width)x\($max.height)@\($max.refresh_rate)\"' | bash
      }

      apply_highrr

      niri msg --json event-stream | while read -r line; do
        if echo "$line" | ${pkgs.gnugrep}/bin/grep -q 'OutputsChanged'; then
          apply_highrr
        fi
      done
    '';
  in {
    options.stars.desktop.niri = {
      enable = lib.mkEnableOption "Niri desktop environment";
      keyboardLayout = lib.mkOption {
        type = lib.types.str;
        default = "us,fr";
        description = "Keyboard layout for Niri workspace keybindings";
      };
    };

    config = lib.mkIf config.stars.desktop.niri.enable {
      programs.niri = {
        enable = true;
        package = inputs.wrapper-modules.wrappers.niri.wrap {
          inherit pkgs;

          settings =
            {
              prefer-no-csd = {};
              spawn-at-startup =
                [
                  [(lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.caelestia)]
                ]
                ++ lib.optionals config.stars.desktop.ratePatch [
                  [(lib.getExe niri-highrr)]
                ];
              xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
              input.keyboard.xkb.layout = config.stars.desktop.niri.keyboardLayout;
              input.touchpad.tap = {};
            }
            // lib.optionalAttrs config.stars.desktop.ratePatch {
              outputs.".*".variable-refresh-rate = {};
            }
            // {
              binds =
                {
                  "Mod+Return".spawn = lib.getExe pkgs.kitty;
                  "Mod+Q".close-window = {};
                  "Mod+S".spawn-sh = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.caelestia} ipc call drawers toggle launcher";
                  "Mod+L".spawn = lib.getExe pkgs.hyprlock;

                  # Apps
                  "Mod+E".spawn = lib.getExe pkgs.thunar;
                  "Mod+R".spawn = ["${lib.getExe pkgs.kitty}" "-e" "${lib.getExe pkgs.yazi}"];
                  "Mod+Shift+B".spawn = lib.getExe pkgs.firefox;
                  "Mod+V".spawn-sh = "${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.rofi} -dmenu | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy";
                  "Print".spawn = ["${lib.getExe pkgs.grimblast}" "copy" "area"];

                  # Layout/Windows
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

                  # Multi-screen
                  "Mod+Shift+Ctrl+Left".move-window-to-monitor-left = {};
                  "Mod+Shift+Ctrl+Right".move-window-to-monitor-right = {};

                  # Media keys
                  "XF86AudioRaiseVolume".spawn = ["${lib.getExe pkgs.pamixer}" "-i" "5"];
                  "XF86AudioLowerVolume".spawn = ["${lib.getExe pkgs.pamixer}" "-d" "5"];
                  "XF86AudioMute".spawn = ["${lib.getExe pkgs.pamixer}" "-t"];
                  "XF86MonBrightnessUp".spawn = ["${lib.getExe pkgs.brightnessctl}" "s" "10%+"];
                  "XF86MonBrightnessDown".spawn = ["${lib.getExe pkgs.brightnessctl}" "s" "10%-"];
                  "XF86AudioPlay".spawn = ["${lib.getExe pkgs.playerctl}" "play-pause"];
                  "XF86AudioNext".spawn = ["${lib.getExe pkgs.playerctl}" "next"];
                  "XF86AudioPrev".spawn = ["${lib.getExe pkgs.playerctl}" "previous"];
                }
                // (builtins.listToAttrs (builtins.concatLists (builtins.genList (x: let
                  ws = x + 1;
                  num = toString (
                    if x == 9
                    then 0
                    else x + 1
                  );
                  # Symbols for FR AZERTY row 1-9, 0
                  azertySyms = ["ampersand" "eacute" "quotedbl" "apostrophe" "parenleft" "minus" "egrave" "underscore" "ccedilla" "agrave"];

                  sym = builtins.elemAt azertySyms x;
                  isFr = lib.hasPrefix "fr" config.stars.desktop.niri.keyboardLayout;
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
                    # Also bind numbers just in case, though they might conflict on FR
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
        };
      };

      # Power profiles and management for Caelestia
      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
        config.niri.default = ["gnome" "gtk"];
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        brightnessctl
        playerctl
        pamixer
        grimblast
        wl-clipboard
        cliphist
        rofi
        thunar
        yazi
        firefox
        hyprlock
      ];
    };
  };

  perSystem = {
    lib,
    pkgs,
    self',
    ...
  }:
    lib.mkIf (pkgs.stdenv.hostPlatform.system != "aarch64-linux") {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        settings = {
          prefer-no-csd = {};
          spawn-at-startup = [
            [(lib.getExe self'.packages.caelestia)]
          ];
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          input.keyboard.xkb.layout = "us,fr";
          input.touchpad.tap = {};
          binds =
            {
              "Mod+Return".spawn = lib.getExe pkgs.kitty;
              "Mod+Q".close-window = {};
              "Mod+S".spawn-sh = "${lib.getExe self'.packages.caelestia} ipc call drawers toggle launcher";
              "Mod+L".spawn = lib.getExe pkgs.hyprlock;

              # Apps
              "Mod+E".spawn = lib.getExe pkgs.thunar;
              "Mod+R".spawn = ["${lib.getExe pkgs.kitty}" "-e" "${lib.getExe pkgs.yazi}"];
              "Mod+Shift+B".spawn = lib.getExe pkgs.firefox;
              "Mod+V".spawn-sh = "${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.rofi} -dmenu | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy";
              "Print".spawn = ["${lib.getExe pkgs.grimblast}" "copy" "area"];

              # Layout/Windows
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

              # Multi-screen
              "Mod+Shift+Ctrl+Left".move-window-to-monitor-left = {};
              "Mod+Shift+Ctrl+Right".move-window-to-monitor-right = {};

              # Media keys
              "XF86AudioRaiseVolume".spawn = ["${lib.getExe pkgs.pamixer}" "-i" "5"];
              "XF86AudioLowerVolume".spawn = ["${lib.getExe pkgs.pamixer}" "-d" "5"];
              "XF86AudioMute".spawn = ["${lib.getExe pkgs.pamixer}" "-t"];
              "XF86MonBrightnessUp".spawn = ["${lib.getExe pkgs.brightnessctl}" "s" "10%+"];
              "XF86MonBrightnessDown".spawn = ["${lib.getExe pkgs.brightnessctl}" "s" "10%-"];
              "XF86AudioPlay".spawn = ["${lib.getExe pkgs.playerctl}" "play-pause"];
              "XF86AudioNext".spawn = ["${lib.getExe pkgs.playerctl}" "next"];
              "XF86AudioPrev".spawn = ["${lib.getExe pkgs.playerctl}" "previous"];
            }
            // (builtins.listToAttrs (builtins.concatLists (builtins.genList (x: let
                ws = x + 1;
                num = toString (
                  if x == 9
                  then 0
                  else x + 1
                );
              in [
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
      };
    };
}
