# feature: ASUS vendor patches
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [asusctl];

  services.asusd.enable = true;
}
