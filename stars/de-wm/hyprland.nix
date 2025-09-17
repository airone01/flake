{
  pkgs,
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
    # rofi-wayland
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # home-manager.users.${config.stars.mainUser} = {
  #   # wayland and hyprland
  #   wayland.windowManager.hyprland.settings = {
  #     "$mainMod" = "SUPER";
  #     bind =
  #       [
  #         # compositor
  #         "$mainMod SHIFT, A, killactive,"
  #         "$mainMod, F, fullscreen,"
  #         "$mainMod, G, togglegroup,"
  #         "$mainMod SHIFT, M, exec, ${pkgs.hyprland} reload"
  #         #"$mainmod SHIFT, E, exec, pkill hyprland"
  #
  #         # apps
  #         ## terminal
  #         "$mainMod, return, exec, ${pkgs.kitty}"
  #         ## rofi
  #         "$mainMod, S, exec, ${pkgs.rofi-wayland} -show drun -show-icons"
  #         ## web browser
  #         "$mainMod SHIFT, F, exec, ${pkgs.firefox}"
  #         ## screenshot tool screen
  #         ", print, exec, ${pkgs.grimblast} copy area"
  #       ]
  #       ++
  #       # workspaces
  #       # binds $mainMod + [shift +] {1..10} to [move to] workspace {1..10}
  #       builtins.concatLists (builtins.genList (
  #           x: let
  #             ws = let
  #               c = (x + 1) / 10;
  #             in
  #               builtins.toString (x + - (c * 10));
  #           in [
  #             "$mainMod, code:${ws}, workspace, ${toString (x + 1)}"
  #             "$mainMod SHIFT, code:${ws}, movetoworkspace, ${toString (x + 1)}"
  #           ]
  #         )
  #         10);
  #
  #     # input config
  #     input = {
  #       kb_layout = "fr,us";
  #       kb_options = "grp:caps_toggle";
  #     };
  #
  #     # exec-once = "${pkgs.bash} ${config.users.users.${config.stars.mainUser}.home}/.config/hypr/start.sh";
  #   };
  # };
}
