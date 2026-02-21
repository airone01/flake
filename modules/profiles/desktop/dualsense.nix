{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  options.stars.profiles.desktop.dualsensePatches =
    lib.mkEnableOption "Sony DualSense controller patches";

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.desktop.enable
      && cfg.profiles.desktop.dualsensePatches
    ) {
      environment.systemPackages = with pkgs; [dualsensectl];

      services.udev = {
        enable = true;

        # https://wiki.archlinux.org/title/Gamepad
        extraRules = ''
          # disable DualShok4/DualSense touchpad acting as mouse
          # USB
          ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
          # Bluetooth (untested, name might vary)
          ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        '';
      };
    };
}
