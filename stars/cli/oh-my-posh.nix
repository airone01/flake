_: {
  name = "oh-my-posh";

  homeConfig = _: {
    programs.oh-my-posh = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;

      useTheme = "M365Princess";
    };
  };
}
