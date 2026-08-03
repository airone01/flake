# feature: user environment
_: {
  flake.nixosModules.userEnv = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.userEnv = lib.mkEnableOption "user environment";

    config = lib.mkIf config.stars.userEnv {
      environment = {
        systemPackages = with pkgs; [
          gh
          pay-respects # thefuck replacement
          zoxide
        ];

        shellAliases = {
          l = "eza -laab --no-filesize --no-permissions --no-time --group --git --icons=auto";
          ll = "eza -laab --icons=auto --git --group";
          neofetch = "pfetch"; # TODO: https://github.com/ThatOneCalculator/NerdFetch
          zz = "tmux";

          # git
          gts = "git status -s";
          gta = "git add";
          gtaa = "git add .";
          gtaan = "git add -N .";
          gtaac = "git add . && git commit";
          gtf = "git fetch";
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
          gtm = "git merge";
          gtma = "git merge --abort";
          gtmc = "git merge --continue";
          gtr = "git restore";
          gtrs = "git reset";

          # just
          jts = "just switch";
          jtc = "just check";

          tmpdir = "cd $(mktemp -d)";
        };
      };

      programs = {
        direnv = {
          enable = true;
          settings.global.hide_env_diff = true;
        };

        git = {
          enable = true;

          lfs.enable = true;
        };

        tmux = {
          enable = true;

          clock24 = true;
        };

        zsh = {
          enable = true;

          enableCompletion = true;
          autosuggestions.enable = true;
          syntaxHighlighting.enable = true;
          ohMyZsh = {
            enable = true;

            plugins = [
              "zsh-fzf-tab"
            ];
          };
        };
      };
    };
  };
}
