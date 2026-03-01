# hey! go check out Searchix, it's pretty dope!
# note for myself: config reference at time of writing:
# https://git.sr.ht/~alanpearce/searchix/tree/b7de525d7fe617674030c493ec4214f2f5a4b887
#
# searchix configuration quirks to remember:
# - the 'download' fetcher strictly requires a '/revision' file to exist at the URL.
# - for nixos options, use the 'channel' fetcher pointing to the 'nixexprs.tar.xz'
#   tarball. searchix knows how to unpack and evaluate it natively.
# - memory leaks: searchix will explode your ram. always set `lowMemory = true;`,
#   keep `batchSize` around 1000, and set a `GOMEMLIMIT` in the systemd service.
# - custom flakes (like nvf): if you use a custom derivation that outputs a json object
#   instead of key-value pairs, you MUST set `jsonDepth = 1;` or it will panic with
#   a jstream.KV cast error.
# - broken symlinks: searchix expects custom options at `$out/share/doc/<name>/options.json`.
#   if your script outputs to `$out/options.json`, either fix the script or set `outputPath`.
# - cache hell: if you update your custom script on github, searchix will use the cached
#   tarball unless you change the commit hash in the url.
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
              url = "https://github.com/airone01/flake/archive/ca32a4b3230ac8705dec67d1dd9f950ff633bcb8.tar.gz";
              importPath = "lib/nvf-searchix.nix";
              attribute = "";
              outputPath = "share/doc/nvf";
              importer = "options";
              jsonDepth = 1;
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
