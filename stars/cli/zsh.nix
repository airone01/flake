{pkgs, config, ...}: {
  home-manager.users.${config.stars.mainUser} = {
    home.shellAliases = {
      l = "eza -laab --no-filesize --no-permissions --no-time --group --git --icons";
      ll = "eza -laab --icons --git --group";
      zz = "zellij -l compact";
      f = "fuck";
    };
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

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
        };
      };
    };

    home.packages = with pkgs; [
      thefuck
      zoxide
    ];
  };

  users.users.${config.stars.mainUser}.shell = pkgs.zsh;

  # needed for the login shell to be zsh
  programs.zsh.enable = true;
}
