# hey! go check out Searchix, it's pretty dope!
# note for myself: config reference at time of writing:
# https://git.sr.ht/~alanpearce/searchix/tree/b7de525d7fe617674030c493ec4214f2f5a4b887
# (also actively developed at https://codeberg.org/alinnow/searchix and https://git.alin.ovh/searchix)
#
# searchix configuration quirks to remember:
# - the 'download' fetcher strictly requires a '/revision' file to exist at the URL.
# - for nixos options, use the 'channel' fetcher pointing to the 'nixexprs.tar.xz'
#   tarball. searchix knows how to unpack and evaluate it natively.
# - for custom option derivations (like my nvf wrapper), searchix appends '/options.json'
#   to whatever `outputPath` is set to. if my script outputs exactly `$out/options.json`,
#   i must set `outputPath = "";`.
# - always set explicit timeouts for heavy derivations to avoid 'context deadline exceeded' errors.
# - indexing is heavily memory intensive. keep batchSize low and GOMEMLIMIT configured.
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars.server.searchix;
  scfg = config.stars.server.enable;

  sandbox = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectClock = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    RestrictNamespaces = true;
    LockPersonality = true;
  };
in {
  options.stars.server.searchix.enable =
    lib.mkEnableOption "Searchix, a nix options and packages search engine";

  config = lib.mkIf (scfg && cfg.enable) {
    systemd.services.searchix = {
      wants = ["network-online.target"];
      after = ["network-online.target"];

      environment = {
        NIX_PATH = "nixpkgs=${pkgs.path}";
        GOMEMLIMIT = "2500MiB";
      };

      serviceConfig =
        sandbox
        // {
          StateDirectory = "searchix";
          # ensure systemd doesn't kill it if heavy indexing delays startup readiness
          TimeoutStartSec = "10m";
        };
    };

    users.users.searchix = {
      isSystemUser = true;
      group = "searchix";
    };
    users.groups.searchix = {};

    services.searchix = {
      enable = true;

      settings = {
        dataPath = "/var/lib/searchix/data";

        importer = {
          batchSize = 1000;
          lowMemory = true;
          timeout = "2h";
          updateAt = "03:00:00";

          sources = {
            darwin = {
              name = "Darwin";
              order = 1;
              key = "darwin";
              enable = true;
              fetcher = "channel";
              importer = "options";
              channel = "darwin";
              url = "https://github.com/LnL7/nix-darwin/archive/master.tar.gz";
              attribute = "docs.optionsJSON";
              importPath = "release.nix";
              timeout = "30m";
              outputPath = "share/doc/darwin";
              jsonDepth = 1;

              repo = {
                type = "github";
                owner = "LnL7";
                repo = "nix-darwin";
              };
            };

            home-manager = {
              enable = true;
              name = "Home Manager";
              key = "home-manager";
              order = 2;
              fetcher = "channel";
              channel = "home-manager";
              url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
              importPath = "default.nix";
              attribute = "docs.json";
              importer = "options";
              timeout = "10m";
              repo = {
                type = "github";
                owner = "nix-community";
                repo = "home-manager";
              };
            };

            nixos = {
              enable = true;
              key = "nixos";
              name = "NixOS";
              order = 0;
              fetcher = "channel";
              channel = "nixos-unstable";
              url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
              importer = "options";
              timeout = "30m";
              repo = {
                owner = "NixOS";
                repo = "nixpkgs";
                type = "github";
              };
            };

            nixpkgs = {
              enable = true;
              key = "nixpkgs";
              attribute = "";
              channel = "nixos-unstable";
              fetcher = "channel-nixpkgs";
              importPath = "";
              importer = "packages";
              jsonDepth = 2;
              name = "Nix Packages";
              order = 3;
              outputPath = "packages.json.br";
              timeout = "30m";
              url = "";
              repo = {
                owner = "NixOS";
                repo = "nixpkgs";
                type = "github";
              };
              programs = {
                attribute = "programs.sqlite";
                enable = true;
              };
            };

            nvf = {
              enable = true;
              name = "NVF";
              key = "nvf";
              order = 5;
              fetcher = "channel";
              url = "https://github.com/airone01/flake/archive/main.tar.gz";
              importPath = "lib/nvf-searchix.nix";
              attribute = "";
              outputPath = "share/doc/nvf";
              importer = "options";
              timeout = "10m";
              repo = {
                type = "github";
                owner = "NotAShelf";
                repo = "nvf";
              };
            };
          };
        };

        web = {
          listenAddress = "localhost";
          port = 51313;
        };
      };
    };
  };
}
