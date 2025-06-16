{config, ...}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.oh-my-posh = {
      enable = true;

      # enableBashIntegration = true; # Disabled so I have one safe shell to rely to when I `nix develop` in a flake or when I break my system
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;

      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./config.omp.json));
    };
  };
}
