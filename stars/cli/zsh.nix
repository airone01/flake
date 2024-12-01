{pkgs, ...}: {
  name = "zsh";

  homeConfig = _: {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          l = "ll --icons --git -a";
          zz = "zellij -l compact";
        };

        oh-my-zsh = {
          enable = true;
          plugins = [
            "eza"
            "git"
            "sudo"
            "thefuck"
            "web-search"
            "zoxide"
          ];
          theme = "robbyrussell";
        };
      };
    };
  };

  packages = with pkgs; [
    thefuck
    zoxide
  ];

  config = {config, ...}: {
    users.users.${config.stars.mainUser}.shell = pkgs.zsh;

    # needed for the login shell to be zsh
    programs.zsh.enable = true;
  };
}
