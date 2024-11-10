{pkgs, ...}: {
  homeConfig = {config, ...}: {
    programs.eza.enable = true;
  };
}
