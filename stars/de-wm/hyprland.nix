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
  ];

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    # extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
  };

  hardware.graphics = {
    package = pkgs.mesa;

    # if you also want 32-bit support (e.g for Steam)
    enable32Bit = true;
    package32 = pkgs.pkgsi686Linux.mesa;
  };

  services.displayManager.gdm = {
    wayland = false;
    enable = true;
  };

  home-manager.users.${config.stars.mainUser} = {
    # wayland and hyprland
    wayland.windowManager.hyprland.settings = {
      "$mainMod" = "SUPER";
      bind =
        [
          # compositor
          "$mainMod SHIFT, A, killactive,"
          "$mainMod, F, fullscreen,"
          "$mainMod, G, togglegroup,"
          "$mainMod SHIFT, M, exec, ${pkgs.hyprland} reload"
          #"$mainmod SHIFT, E, exec, pkill hyprland"

          # apps
          ## terminal
          "$mainMod, return, exec, ${pkgs.kitty}"
          ## rofi
          "$mainMod, S, exec, ${pkgs.rofi-wayland} -show drun -show-icons"
          ## web browser
          "$mainMod SHIFT, F, exec, ${pkgs.firefox}"
          ## screenshot tool screen
          ", print, exec, ${pkgs.grimblast} copy area"
        ]
        ++
        # workspaces
        # binds $mainMod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + - (c * 10));
            in [
              "$mainMod, code:${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, code:${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10);

      # input config
      input = {
        kb_layout = "fr,us";
        kb_options = "grp:caps_toggle";
      };
    };
  };
}
