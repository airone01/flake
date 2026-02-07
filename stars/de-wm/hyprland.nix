{
  lib,
  pkgs,
  ...
}: let
  wallpaperImg = pkgs.fetchurl {
    # https://wallhaven.cc/w/6llz6l
    # wallpaper uploaded by Gone65478
    url = "https://w.wallhaven.cc/full/6l/wallhaven-6llz6l.jpg";
    sha256 = "1xwi8cbgx08b83g9f560yyzssb42yab62hlvnr78cjkrdyxapbwf";
  };
in {
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

  # Thunar extra
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  programs.hyprland = {
    enable = true;
    # Use the system package instead of the flake input to avoid build failures
    # caused by sandbox restrictions (git clone) and cache misses.
    # This also ensures OpenGL/Mesa drivers stay in sync with the system.
    package = pkgs.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    # extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
  };

  stars.home = {
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
          "dunst" # open notification deamon
          # "swww-daemon" # open wallpaper deamon
          "swww img -t none ${wallpaperImg}" # change wallpaper
          "waybar" # bar
          # "nm-applet --indicator" # open network manager icon
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" # ui for pasword auth
          "wl-paste --type text --watch cliphist store" # clipboard
          "wl-paste --type image --watch cliphist store" # clipboard
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
          kb_layout = lib.mkDefault "us";
          follow_mouse = 1; # focus follow mouse
        };

        debug.disable_logs = false;
      };
    };

    xdg.configFile = {
      "eww/eww.yuck".source = ./eww/eww.yuck;
      "eww/eww.scss".source = ./eww/eww.scss;
    };
  };
}
