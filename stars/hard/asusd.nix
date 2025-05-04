{pkgs, ...}: {
  services.asusd = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [asusctl];
}
