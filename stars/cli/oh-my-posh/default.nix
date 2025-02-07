{config, ...}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.oh-my-posh = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;

      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./config.omp.json));
    };
  };
}
