# feature: PlayStation PS5 DualSense controller patches
{pkgs, ...}: {
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
}
