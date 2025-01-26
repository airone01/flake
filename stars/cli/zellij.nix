{pkgs, config, ...}: {
  home-manager.users.${config.stars.mainUser} = {
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
