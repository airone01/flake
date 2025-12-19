{
  pkgs,
  inputs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # diy rust widgets
    eww
    quickshell

    # notifications
    libnotify
    dunst

    # wallpaper deamon
    swww

    # app launcher
    rofi

    # screen sharing
    xdg-desktop-portal-hyprland

    kitty

    xfce.thunar
    xfce.thunar-volman # Manage USB sticks
    xfce.thunar-archive-plugin # Right-click -> Extract
    yazi

    networkmanagerapplet # might changer later

    brightnessctl
    playerctl
    pamixer # or wireplumber might change later
  ];

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    # extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
  };

  home-manager.users.${config.stars.mainUser} = {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";

        exec-once = [
          # notification daemon
          "dunst"
          # wallpaper daemon
          "swww-daemon"
          # network manager icon
          "nm-applet --indicator"
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

        # bindel = bind with repeat
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
        ];

        # input config
        input = {
          kb_layout = "fr,us";
          kb_options = "grp:caps_toggle"; # caps lock switches layout
          follow_mouse = 1; # focus follow mouse
        };

        debug.disable_logs = false;
      };
    };

    xdg.configFile = {
      "eww/eww.yuck".source = ./eww/eww.yuck;
      "eww/eww.scss".source = ./eww/eww.scss;

      "quickshell/shell.qml".source = ./qshell/shell.qml;
    };
  };
}
