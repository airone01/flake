{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;

  rofi-power = pkgs.writeShellScriptBin "rofi-power" ''
    entries="⏻ Shutdown\n Reboot\n⏾ Suspend\n󰍃 Logout"
    selected=$(echo -e $entries | ${pkgs.rofi}/bin/rofi -dmenu -i -p "Power")
    case $selected in
      *Shutdown) systemctl poweroff ;;
      *Reboot) systemctl reboot ;;
      *Suspend) systemctl suspend ;;
      *Logout) hyprctl dispatch exit ;;
    esac
  '';

  rofi-sound = pkgs.writeShellScriptBin "rofi-sound" ''
    sink=$(${pkgs.pulseaudio}/bin/pactl list short sinks | ${pkgs.rofi}/bin/rofi -dmenu -i -p "Select Audio Output")
    id=$(echo "$sink" | awk '{print $1}')
    [ -n "$id" ] && ${pkgs.pulseaudio}/bin/pactl set-default-sink "$id"
  '';
in {
  options.stars.profiles.desktop.hyprland.rofi.enable =
    lib.mkEnableOption "Rofi selectors" // {default = true;};

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.desktop.enable
      && cfg.profiles.desktop.desktopEnv == "hyprland"
      && cfg.profiles.desktop.hyprland.rofi.enable
    ) {
      environment.systemPackages = with pkgs; [
        rofi-power
        rofi-sound
        networkmanager_dmenu
      ];

      home-manager.users.${cfg.mainUser}.programs.waybar.settings = {
        "network" = {
          "format" = "{ifname}";
          "format-wifi" = "  {essid} ({signalStrength}%)";
          "on-click-right" = "networkmanager_dmenu";
        };

        "pulseaudio" = {
          "format" = "  {volume}%";
          "on-click-right" = "rofi-sound";
        };

        "custom/power" = {
          "format" = "⏻";
          "on-click" = "rofi-power";
          "tooltip" = false;
        };
      };
    };
}
