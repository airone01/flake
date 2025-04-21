_: {
  # Enable Nvidia drivers
  hardware.nvidia.modesetting.enable = true;

  # Force usage of Nvidia drivers in GNOME
  services.xserver.videoDrivers = ["nvidia"];
}
