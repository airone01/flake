{pkgs, ...}: {
  stars.home.programs.ripgrep.enable = true;

  environment.systemPackages = with pkgs; [
    ripgrep
  ];
}
