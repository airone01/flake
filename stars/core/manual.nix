{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    man-pages
  ];
}
