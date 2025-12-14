{
  pkgs,
  inputs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # diy rust widgets
    eww

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

  # hardware.graphics = {
  #   package = pkgs.mesa;
  #
  #   # if you also want 32-bit support (e.g for Steam)
  #   enable32Bit = true;
  #   package32 = pkgs.pkgsi686Linux.mesa;
  # };

  # services.displayManager.gdm = {
  #   wayland = false;
  #   enable = true;
  # };

  home-manager.users.${config.stars.mainUser} = {
    # wayland and hyprland
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        bind =
          [
            # compositor
            "$mod SHIFT, A, killactive,"
            "$mod, F, fullscreen,"
            "$mod, G, togglegroup,"
            "$mod SHIFT, E, exit," # exit hyprland to DM
            "$mod, E, exec, thunar"
            "$mod, R, exec, kitty -e yazi"
            "$mod SHIFT, M, exec, hyprctl reload"

            # apps
            ## terminal
            "$mod, return, exec, ${pkgs.kitty}/bin/kitty"
            ## rofi
            "$mod, S, exec, ${pkgs.rofi}/bin/rofi -show drun -show-icons"
            ## web browser
            "$mod SHIFT, F, exec, ${pkgs.firefox}/bin/firefox"
            ## screenshot tool screen
            ", print, exec, ${pkgs.grimblast}/bin/grimblast copy area"
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

        # input config
        input = {
          kb_layout = "fr,us";
          kb_options = "grp:caps_toggle"; # caps lock switches layout
          follow_mouse = 1; # focus follow mouse
        };

        debug.disable_logs = false;
      };
    };
  };
}
