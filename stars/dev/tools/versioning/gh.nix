{pkgs, ...}: {
  stars.home.programs.gh.enable = true;

  environment.systemPackages = with pkgs; [gh];
}
