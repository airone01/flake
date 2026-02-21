{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
  wallpaperImg = pkgs.fetchurl {
    # https://wallhaven.cc/w/6llz6l
    # wallpaper uploaded by Gone65478
    url = "https://w.wallhaven.cc/full/6l/wallhaven-6llz6l.jpg";
    sha256 = "1xwi8cbgx08b83g9f560yyzssb42yab62hlvnr78cjkrdyxapbwf";
  };
in {
  options.stars.profiles.desktop.hyprRatePatches =
    lib.mkEnableOption "hyprland high rate screen configuration";

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.desktop.enable
      && cfg.profiles.desktop.desktopEnv == "hyprland"
    )
    (lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [
          # libnotify # notifications
          # dunst # notifications
          # swww # wallpaper deamon
          # rofi # app launcher
          xdg-desktop-portal-hyprland # screen sharing
          # kitty # terminal emulator
          thunar # file manager
          thunar-volman # manage USB sticks
          thunar-archive-plugin # right-click -> extract
          yazi # another file manager
          networkmanagerapplet # network manager applet; might changer later
          brightnessctl # brightness controller
          playerctl # media players controller
          pamixer # or wireplumber might change later
          wl-clipboard # Wayland clipboard
          # cliphist # clipboard manager
          # hyprlock # lock screen
          pavucontrol # used by waybar
        ];

        # Thunar extras
        services.gvfs.enable = true; # mount, trash, and other functionalities
        services.tumbler.enable = true; # thumbnail support for images

        programs.hyprland = {
          enable = true;
          # use the system package instead of the flake input to avoid build failures
          # caused by sandbox restrictions (git clone) and cache misses.
          # this also ensures OpenGL/Mesa drivers stay in sync with the system.
          package = pkgs.hyprland;
          # make sure to also set the portal package, so that they are in sync
          portalPackage = pkgs.xdg-desktop-portal-hyprland;
          xwayland.enable = true;
        };

        xdg.portal = {
          enable = true;
          # extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
        };

        boot.kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "loglevel=3"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_level=3"
        ];

        home-manager.users.${config.stars.mainUser} = {
          programs = {
            hyprlock.enable = true;
            kitty.enable = true;
            rofi.enable = true;
            waybar.enable = true;
          };

          services = {
            cliphist.enable = true;
            dunst.enable = true;
            playerctld.enable = true;
            swww.enable = true;
          };

          home.pointerCursor = {
            enable = true;
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Ice";
          };

          wayland.windowManager.hyprland = {
            enable = true;
            settings = {
              "$mod" = "SUPER";

              exec-once = [
                # notification deamon
                "dunst"
                # set wallpaper
                "swww img -t none ${wallpaperImg}"
                "waybar"
                # "nm-applet --indicator" # network manager icon
                # ui for pasword auth
                "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
                # clipboard
                "wl-paste --type text --watch cliphist store"
                "wl-paste --type image --watch cliphist store"
              ];

              bind =
                [
                  # compositor
                  "$mod SHIFT, A, killactive,"
                  "$mod, F, fullscreen,"
                  "$mod, G, togglegroup,"
                  "$mod SHIFT, E, exit," # exit hyprland to DM
                  "$mod SHIFT, M, exec, hyprctl reload"
                  "$mod, L, exec, hyprlock"
                  "$mod, P, pin"

                  # windows
                  ## change focus
                  "SUPER, left, movefocus, l"
                  "SUPER, right, movefocus, r"
                  "SUPER, up, movefocus, u"
                  "SUPER, down, movefocus, d"
                  ## move window
                  "SUPER SHIFT, left, movewindow, l"
                  "SUPER SHIFT, right, movewindow, r"
                  "SUPER SHIFT, up, movewindow, u"
                  "SUPER SHIFT, down, movewindow, d"

                  # apps
                  ## terminal
                  "$mod, return, exec, ${pkgs.kitty}/bin/kitty"
                  ## rofi
                  "$mod, S, exec, ${pkgs.rofi}/bin/rofi -show drun -show-icons"
                  ## web browser
                  "$mod SHIFT, F, exec, ${pkgs.firefox}/bin/firefox"
                  ## screenshot tool screen
                  ", print, exec, ${pkgs.grimblast}/bin/grimblast copy area"
                  ## file managers
                  "$mod, E, exec, thunar"
                  "$mod, R, exec, kitty -e yazi"

                  # other
                  ## view clipboard history
                  "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
                ]
                ++
                # workspaces
                # binds $mod + [shift +] {1..9,0} to [move to] workspace {1..10}
                builtins.concatLists (builtins.genList (
                    x: let
                      ws = x + 1;
                      c = x + 10;
                    in [
                      "$mod, code:${toString c}, workspace, ${toString ws}"
                      "$mod SHIFT, code:${toString c}, movetoworkspace, ${toString ws}"
                    ]
                  )
                  10);

              # bind mouse
              bindm = [
                "SUPER, mouse:272, movewindow"
                "SUPER, mouse:273, resizewindow"
              ];

              # bind with repeat
              binde = [
                "SUPER CTRL, right, resizeactive, 20 0"
                "SUPER CTRL, left, resizeactive, -20 0"
                "SUPER CTRL, up, resizeactive, 0 -20"
                "SUPER CTRL, down, resizeactive, 0 20"
              ];

              # bind with repeat
              bindel = [
                # system controls
                ## volume
                ", XF86AudioRaiseVolume, exec, pamixer -i 5"
                ", XF86AudioLowerVolume, exec, pamixer -d 5"
                ", XF86AudioMute, exec, pamixer -t"
                ## brightness
                ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
                ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
                ## media player
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioNext, exec, playerctl next"
                ", XF86AudioPrev, exec, playerctl previous"

                # windows
                ## resize
                "SUPER CTRL, right, resizeactive, 20 0"
                "SUPER CTRL, left, resizeactive, -20 0"
                "SUPER CTRL, up, resizeactive, 0 -20"
                "SUPER CTRL, down, resizeactive, 0 20"
              ];

              input = {
                kb_layout = lib.mkDefault "us";
                follow_mouse = 1; # focus follow mouse
              };

              # appearance
              general = {
                border_size = 2;

                "col.active_border" = "rgba(f59e0bee) rgba(d97706ee) 45deg";
                "col.inactive_border" = "rgba(525252aa)";

                layout = "dwindle";
              };

              decoration = {
                rounding = 10;

                # drop shadow?
                active_opacity = 1.0;
                inactive_opacity = 1.0;

                shadow = {
                  enabled = true;
                  range = 4;
                  render_power = 3;
                  color = "rgba(1a1a1aee)";
                };

                blur = {
                  enabled = true;
                  size = 3;
                  passes = 1;
                };
              };

              windowrule = [
                # prevent steam from stealing focus when it launches or updates
                "suppress_event activatefocus, match:class ^(steam)$"
                # prevent steam notifications from stealing focus
                "no_focus 1, match:class ^(steam)$, match:title ^(notificationtoasts_.*_desktop)$"
                # keep games fullscreen even if steam tries to pop up
                "stay_focused 1, match:title ^()$, match:class ^(steam)$"
                # "minimize_to_tray 1, match:title ^(Steam)$"
              ];

              debug.disable_logs = false;
            };
          };
        };
      }
      (lib.mkIf cfg.profiles.desktop.hyprRatePatches
        {
          home-manager.users.${config.stars.mainUser} = {
            wayland.windowManager.hyprland.settings.monitor = [", highrr, auto, 1"];
          };
        })
    ]);
}
