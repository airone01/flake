_:
# Hey! Go check out Searchix, it's pretty dope!
# Note for myself: config reference at time of writing:
# https://git.sr.ht/~alanpearce/searchix/tree/b7de525d7fe617674030c493ec4214f2f5a4b887
{
  services.searchix = {
    enable = true;

    settings = {
      dataPath = "/var/lib/searchix/data";
      logLevel = "info";

      importer = {
        batchSize = 10000;
        lowMemory = true;
        timeout = "30m";
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
            timeout = "5m0s";
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

          # home-manager = {
          #   enable = true;
          #   key = "home-manager";
          #   attribute = "docs.json";
          #   channel = "home-manager";
          #   fetcher = "channel";
          #   importPath = "default.nix";
          #   importer = "options";
          #   jsonDepth = 1;
          #   name = "Home Manager";
          #   order = 2;
          #   outputPath = "share/doc/home-manager";
          #   timeout = "5m";
          #   url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
          #   repo = {
          #     owner = "nix-community";
          #     repo = "home-manager";
          #     type = "github";
          #   };
          #   programs = {
          #     attribute = "";
          #     enable = false;
          #   };
          # };

          nixos = {
            enable = true;
            key = "nixos";
            attribute = "options";
            channel = "nixpkgs";
            fetcher = "channel";
            importPath = "nixos/release.nix";
            importer = "options";
            jsonDepth = 1;
            name = "NixOS";
            order = 0;
            outputPath = "share/doc/nixos";
            timeout = "5m";
            url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
            repo = {
              owner = "NixOS";
              repo = "nixpkgs";
              type = "github";
            };
            programs = {
              attribute = "";
              enable = false;
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
            timeout = "15m";
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

          nur = {
            enable = true;
            key = "nur";
            attribute = "";
            channel = "";
            fetcher = "download";
            importPath = "";
            importer = "packages";
            jsonDepth = 1;
            name = "NUR";
            order = 4;
            outputPath = "";
            timeout = "5m";
            url = "https://alanpearce.github.io/nix-options/nur";
            repo = {
              owner = "nix-community";
              repo = "nur";
              type = "github";
            };
            programs = {
              attribute = "";
              enable = false;
            };
          };

          # # Custom NVF source
          # nvf = {
          #   enable = true;
          #   key = "nvf";
          #   name = "NVF";
          #   order = 5;
          #
          #   # ✅ Use the proper GitHub-style channel fetcher
          #   fetcher = "channel";
          #   channel = "main";
          #   timeout = "5m";
          #
          #   importer = "options";
          #   importPath = "docs/default.nix";
          #   attribute = "docs.json";
          #   jsonDepth = 1;
          #   outputPath = "share/doc/nvf";
          #
          #   repo = {
          #     owner = "NotAShelf";
          #     repo = "nvf";
          #     type = "github";
          #   };
          # };
        };
      };

      web = {
        listenAddress = "localhost";
        port = 51313;
      };
    };
  };
}
#   services.searchix = {
#     enable = true;
#     settings = lib.mkMerge [{
#       web = {
#         port = 51313;
#         listenAddress = "localhost";
#         # Don't change baseURL here, already done in traefik star
#       };
#
#       # Periodic data importer settings
#       # importer = {
#       # sources = {
#       #   home-manager.enable = true;
#       #   darwin.enable = true;
#       #   nur.enable = true;
#       #
#       #   # Those are already default; here just in case
#       #   nixos.enable = true;
#       #   nixpkgs.enable = true;
#       #
#       #   custom stuff
#       #   "nvf" = {
#       #     enable = true;
#       #     key = "nvf";
#       #     name = "NVF";
#       #     order = 5;
#       #
#       #     fetcher = "download";
#       #     url = "https://github.com/NotAShelf/nvf/archive/master.tar.gz";
#       #     timeout = "5m0s";
#       #
#       #     importer = "options";
#       #     importPath = "docs/default.nix";
#       #     attribute = "docs.json";
#       #     jsonDepth = 1;
#       #
#       #     repo = {
#       #       owner = "NotAShelf";
#       #       repo = "nvf";
#       #       type = "github";
#       #     };
#       #   };
#       # };
#       # };
#     };
#   };
# }

