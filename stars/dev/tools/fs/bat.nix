{pkgs, ...}: {
  stars.home = [{programs.bat.enable = true;}];

  environment.systemPackages = with pkgs; [
    eza
  ];
}
