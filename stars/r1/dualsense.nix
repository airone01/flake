{pkgs, ...}: {
  services.udev = {
    enable = true;

    # Yoinked from https://wiki.archlinux.org/title/Gamepad
    extraRules = ''
      # Disable DS4 touchpad acting as mouse
      # USB
      ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      # Bluetooth
      ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };

  environment.systemPackages = with pkgs; [dualsensectl];
}
