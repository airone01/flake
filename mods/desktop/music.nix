{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mixxx
  ];
}
