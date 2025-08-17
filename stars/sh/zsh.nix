{
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser} = {
    home.packages = with pkgs; [
      pay-respects # thefuck replacement
      zoxide
    ];

    home.shellAliases = {
      l = "eza -laab --no-filesize --no-permissions --no-time --group --git --icons=auto";
      ll = "eza -laab --icons=auto --git --group";
      neofetch = "pfetch";
      zz = "zellij -l compact";
    };

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initContent = ''
          compdef l=eza
          compdef ll=eza
          compdef zz=zellij
        '';
      };
    };
  };

  users.users.${config.stars.mainUser}.shell = pkgs.zsh;

  # needed for the login shell to be zsh
  programs.zsh.enable = true;
}
