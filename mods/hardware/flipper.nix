# feature: Flipper Zero support
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qFlipper
  ];

  hardware.flipperzero.enable = true;
}
