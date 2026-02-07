{pkgs, ...}: {
  stars.home = {
    programs.eza.enable = true;
  };

  environment.systemPackages = with pkgs; [
    eza
  ];
}
