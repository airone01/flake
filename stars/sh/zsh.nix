{
  pkgs,
  config,
  ...
}: {
  stars.home = [
    {
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
        gtaan = "git add -N .";
        gtaac = "git add . && git commit";
        gtc = "git commit";
        gtcc = "git checkout";
        gtccb = "git checkout -b";
        gtd = "git diff";
        gtdc = "git diff --cached";
        gtrm = "git rm --cached";
        gtp = "git push";
        gtpu = "git push -u $(git remote) $(git rev-parse --abbrev-ref HEAD)";
        gtpl = "git pull";
        gtl = "git log --all --oneline --graph";
        gtlo = "git log --oneline";

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
    }
  ];

  users.users.${config.stars.mainUser}.shell = pkgs.zsh;

  # needed for the login shell to be zsh
  programs.zsh.enable = true;
}
