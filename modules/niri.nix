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
  }: {
    options.stars.desktop.niri.enable = lib.mkEnableOption "Niri desktop environment";

    config = lib.mkIf config.stars.desktop.niri.enable {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };

      # Power profiles and management for Caelestia
      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;

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
  }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      settings = {
        prefer-no-csd = true;
        spawn-at-startup = [
          [(lib.getExe self'.packages.caelestia)]
        ];
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        input.keyboard.xkb.layout = "fr,us";
        input.touchpad.tap = null;
        binds =
          {
            "Mod+Return".spawn = lib.getExe pkgs.kitty;
            "Mod+Q".close-window = null;
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.caelestia} ipc call drawers toggle launcher";
            "Mod+L".spawn = lib.getExe pkgs.hyprlock;

            # Apps
            "Mod+E".spawn = lib.getExe pkgs.thunar;
            "Mod+R".spawn = ["${lib.getExe pkgs.kitty}" "-e" "${lib.getExe pkgs.yazi}"];
            "Mod+Shift+B".spawn = lib.getExe pkgs.firefox;
            "Mod+V".spawn-sh = "${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.rofi} -dmenu | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy";
            "Print".spawn = ["${lib.getExe pkgs.grimblast}" "copy" "area"];

            # Layout/Windows
            "Mod+F".maximize-column = null;
            "Mod+Shift+F".fullscreen-window = null;
            "Mod+C".center-column = null;
            "Mod+P".toggle-window-floating = null;

            "Mod+Left".focus-column-left = null;
            "Mod+Right".focus-column-right = null;
            "Mod+Up".focus-window-up = null;
            "Mod+Down".focus-window-down = null;

            "Mod+Shift+Left".move-column-left = null;
            "Mod+Shift+Right".move-column-right = null;
            "Mod+Shift+Up".move-window-up = null;
            "Mod+Shift+Down".move-window-down = null;

            "Mod+Ctrl+Left".set-column-width = "-10%";
            "Mod+Ctrl+Right".set-column-width = "+10%";
            "Mod+Ctrl+Up".set-window-height = "-10%";
            "Mod+Ctrl+Down".set-window-height = "+10%";

            # Multi-screen
            "Mod+Shift+Ctrl+Left".move-window-to-monitor-left = null;
            "Mod+Shift+Ctrl+Right".move-window-to-monitor-right = null;

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
            in [
              {
                name = "Mod+${num}";
                value.focus-workspace = ws;
              }
              {
                name = "Mod+${sym}";
                value.focus-workspace = ws;
              }
              {
                name = "Mod+Shift+${num}";
                value.move-column-to-workspace = ws;
              }
              {
                name = "Mod+Shift+${sym}";
                value.move-column-to-workspace = ws;
              }
            ])
            10)));
      };
    };
  };
}
