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
      home-manager.users.${config.stars.mainUser} = {
        home = {
          packages = with pkgs; [
            pay-respects # thefuck replacement
            zellij
            zoxide
          ];

          shellAliases = {
            l = "eza -laab --no-filesize --no-permissions --no-time --group --git --icons=auto";
            ll = "eza -laab --icons=auto --git --group";
            neofetch = "pfetch"; # TODO: https://github.com/ThatOneCalculator/NerdFetch
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
            gtm = "git merge";
            gtma = "git merge --abort";
            gtmc = "git merge --continue";
            gtr = "git restore";
            gtrs = "git reset";

            # just
            jts = "just switch";
            jtc = "just check";
          };
        };

        programs = {
          direnv = {
            enable = true;

            nix-direnv.enable = true;
            enableBashIntegration = true;
            enableFishIntegration = true;
            enableNushellIntegration = true;
            enableZshIntegration = true;

            config.global.hide_env_diff = true;
          };

          git = {
            enable = true;

            # TODO: enable signing
            signing.format = null;

            settings = {
              user.name = "airone01";
              user.email = "21955960+airone01@users.noreply.github.com";
            };
          };

          gh = {
            enable = true;

            gitCredentialHelper = {
              enable = true;

              hosts = ["https://github.com" "https://gist.github.com"];
            };
          };

          oh-my-posh = {
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

          zellij = {
            enable = true;

            settings.show_startup_tips = false;
          };

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
    };
  };
}
