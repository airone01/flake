{config, ...}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.oh-my-posh = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;

      useTheme = "bubblesextra";
    };
  };
}
