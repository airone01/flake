_: {
  stars.home.programs.oh-my-posh = {
    enable = true;

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    settings = builtins.fromJSON (builtins.readFile (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/df8f599351258f749dc9959af666cd9037340567/themes/huvix.omp.json";
      sha256 = "0sjxvrjpc4l6rb6z2sqqxx3m57qrghqd9w9c4qpbjprxpfhl6bqq";
    }));
  };
}
