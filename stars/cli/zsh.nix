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
          l = "eza -laag --git --icons";
          zz = "zellij -l compact";
        };
      };
    };
  };

  config = {config, ...}: {
    users.users.${config.stars.mainUser}.shell = pkgs.zsh;

    # needed for the login shell to be zsh
    programs.zsh.enable = true;
  };
}
