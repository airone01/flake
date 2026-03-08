{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  options.stars.profiles.desktop.hyprland.waybar.enable =
    lib.mkEnableOption "Waybar" // {default = true;};

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.desktop.enable
      && cfg.profiles.desktop.desktopEnv == "hyprland"
      && cfg.profiles.desktop.hyprland.waybar.enable
    ) {
      environment.systemPackages = with pkgs; [pavucontrol];

      home-manager.users.${cfg.mainUser} = {
        wayland.windowManager.hyprland.settings.exec-once = ["waybar"];

        programs.waybar = {
          enable = true;
          settings = {
            mainBar = {
              modules-left = ["hyprland/workspaces"];
              modules-center = ["hyprland/window"];
              modules-right = ["network" "pulseaudio" "clock"];
            };
          };
        };
      };
    };
}
