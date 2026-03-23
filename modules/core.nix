{inputs, ...}: {
  flake.nixosModules.core = {
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.sops-nix.nixosModules.sops];

    options.stars = {
      mainUser = lib.mkOption {
        description = "Name of the main user.";
        type = lib.types.str;
        example = "user";
      };

      core = lib.mkEnableOption "the core system configurations";
    };

    config = lib.mkIf config.stars.core {
      users.users.${config.stars.mainUser} = {
        shell = pkgs.zsh;
        # UID > 1000
        isNormalUser = true;
        # gives super user access
        extraGroups = ["wheel" "dialout"];
        # other groups are added to the user in their respective modules
      };

      environment.systemPackages = with pkgs; [
        age
        bat
        btop
        cachix
        curl
        eza
        gh
        git
        htop
        fzf
        nmap
        openssh
        ripgrep
        sops
        ssh-to-age
        unzip
        wget
      ];

      nix = {
        # most of these settings were yanked from @sioodmy's dotfiles
        # https://github.com/sioodmy/dotfiles/blob/d82f7db5080d0ff4d4920a11378e08df365aeeec/system/nix/default.nix

        # compiling lix takes forever, using nixpkgs's version
        # https://lix.systems/add-to-config/
        package = pkgs.lix;

        settings = {
          experimental-features = ["nix-command" "flakes"];

          builders-use-substitutes = true;
          keep-derivations = true;
          keep-outputs = true;
          auto-optimise-store = true;
          eval-cache = true;
          warn-dirty = false;

          sandbox = true;
          max-jobs = "auto";
          # continue building derivations if one fails
          keep-going = true;
          log-lines = 20;
          extra-experimental-features = ["flakes" "nix-command"];

          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://airone01.cachix.org"
            "https://pre-commit-hooks.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "airone01.cachix.org-1:+HKTZmTKthiKMNQzABHWDSMEUFC233bbkKmrjh8C6sc="
            "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
          ];
        };

        # garbage collection supposedly kills SSD
        # https://nixos.org/guides/nix-pills/11-garbage-collector.html
        # https://blog.tiserbox.com/posts/2024-08-07-a-story-about-garbage-collection-on-nixos
        gc.automatic = false;

        # make builds run with low priority so my system stays responsive
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
      };

      system.switch = {
        # disabling this supposedly makes rebuilds a little faster,
        # but it breaks stuff
        enable = true;
      };

      # configs for the sops-nix flake
      # this is not the sops CLI
      sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      };

      programs = {
        nh = {
          enable = true;
          flake = "${config.users.users.${config.stars.mainUser}.home}/.config/nixos";
        };

        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };

        # needed for the login shell to be zsh
        zsh.enable = true;
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";

        sharedModules = with inputs; [
          nvf.homeManagerModules.default
        ];

        users.${config.stars.mainUser} = {
          home = {
            username = config.stars.mainUser;
            homeDirectory = "/home/${config.stars.mainUser}";
            inherit (config.system) stateVersion;

            packages = with pkgs; [
              pay-respects # thefuck replacement, TODO: configure
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
  };
}
