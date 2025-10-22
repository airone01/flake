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
      zz = "zellij";

      # git
      gts = "git status -s";
      gta = "git add";
      gtaa = "git add .";
      gtc = "git commit";
      gtcc = "git checkout";
      gtd = "git diff";
      gtdc = "git diff --cached";
      gtrm = "git remove --cached";
      gtp = "git push";
      gtpl = "git pull";

      # just
      jts = "just switch";
      jtc = "just check";
    };

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        plugins = [
          {
            name = "fzf-tab";
            src = pkgs.fetchFromGitHub {
              owner = "Aloxaf";
              repo = "fzf-tab";
              rev = "v1.1.2";
              sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
            };
          }
        ];
      };
    };
  };

  users.users.${config.stars.mainUser}.shell = pkgs.zsh;

  # needed for the login shell to be zsh
  programs.zsh.enable = true;
}
