# hey! go check out Searchix, it's pretty dope!
# note for myself: config reference at time of writing:
# https://git.sr.ht/~alanpearce/searchix/tree/b7de525d7fe617674030c493ec4214f2f5a4b887
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars.server.searchix;
  scfg = config.stars.server.enable;
in {
  options.stars.server.searchix.enable =
    lib.mkEnableOption "Searchix, a nix options and packages search engine";

  config = lib.mkIf (scfg && cfg.enable) {
    systemd.services.searchix.environment = {
      NIX_PATH = "nixpkgs=${pkgs.path}";
    };

    services.searchix = {
      enable = true;

      settings = {
        dataPath = "/var/lib/searchix/data";

        importer = {
          batchSize = 10000;
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

              # programs = {
              #   enable = false;
              #   attribute = "";
              # };

              # manPages = {
              #   enable = false;
              #   attribute = "";
              # };
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
              repo = {
                type = "github";
                owner = "nix-community";
                repo = "home-manager";
              };
            };

            nixos = {
              enable = true;
              key = "nixos";
              fetcher = "download";
              name = "NixOS";
              order = 0;
              outputPath = "share/doc/nixos";
              timeout = "30m";
              url = "https://channels.nixos.org/nixos-unstable/options.json.br";

              repo = {
                owner = "NixOS";
                repo = "nixpkgs";
                type = "github";
              };

              # programs = {
              #   attribute = "";
              #   enable = false;
              # };
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

            # The 'download' fetcher in Searchix strictly requires a 'revision' file
            # to exist at the URL (e.g. .../data/revision). The official NUR endpoint
            # only provides 'packages.json', so Searchix errors out. Hence must be
            # disabled.
            # nur = {
            #   enable = true;
            #   key = "nur";
            #   attribute = "";
            #   channel = "";
            #   fetcher = "download";
            #   importPath = "";
            #   importer = "packages";
            #   jsonDepth = 1;
            #   name = "NUR";
            #   order = 4;
            #   outputPath = "";
            #   timeout = "30m";
            #   url = "https://nur.nix-community.org/data/packages.json";
            #   repo = {
            #     owner = "nix-community";
            #     repo = "nur";
            #     type = "github";
            #   };
            #   programs = {
            #     attribute = "";
            #     enable = false;
            #   };
            # };

            nvf = {
              enable = true;
              name = "NVF";
              key = "nvf";
              order = 5;
              fetcher = "channel";
              url = "https://github.com/airone01/flake/archive/fix/hercules-patches.tar.gz";
              importPath = "lib/nvf-searchix.nix";
              attribute = "";
              importer = "options";
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
