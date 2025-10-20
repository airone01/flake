{config, ...}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.oh-my-posh = {
      enable = true;

      enableBashIntegration = false;
      # Disabled so I have one safe shell to rely to when I `nix develop` in a flake or when I break my system
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;

      settings = builtins.fromJSON (builtins.readFile (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/df8f599351258f749dc9959af666cd9037340567/themes/huvix.omp.json";
        sha256 = "0sjxvrjpc4l6rb6z2sqqxx3m57qrghqd9w9c4qpbjprxpfhl6bqq";
      }));
    };
  };
}
