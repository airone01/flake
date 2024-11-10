{pkgs, ...}: {
  packages = with pkgs; [zellij];

  homeConfiguration = _: {
    programs.zellij = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;

      settings = {
        theme = "tokyo-night";
      };
    };
  };
}
