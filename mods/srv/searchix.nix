# feature: Searchix nix options search engine configuration and integration with other services
{
  enableAnubis ? false,
  enableTraefik ? false,
}: {
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  appPort = 51313;
  anubisPort = 3033;
  traefikTarget =
    if enableAnubis
    then anubisPort
    else appPort;

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
  imports = [inputs.searchix.nixosModules.web];

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
        # ensure systemd doesn't kill Searchix if heavy indexing delays startup readiness
        TimeoutStartSec = "10m";
      };
  };

  users.users.searchix = {
    isSystemUser = true;
    group = "searchix";
  };
  users.groups.searchix = {};

  services = {
    searchix = {
      enable = true;

      settings = {
        dataPath = "/var/lib/searchix/data";

        web = {
          listenAddress = "localhost";
          port = 51313;
        };

        importer = {
          batchSize = 1000;
          lowMemory = true;
          timeout = "2h";
          updateAt = "03:00:00";

          sources = {
            nixos = {
              enable = true;
              key = "nixos";
              name = "NixOS";
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

            home-manager = {
              enable = true;
              name = "Home Manager";
              key = "home-manager";
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

            darwin = {
              name = "Darwin";
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

            nvf = {
              enable = true;
              name = "NVF";
              key = "nvf";
              fetcher = "channel";
              url = "https://github.com/airone01/flake/archive/main.tar.gz";
              importPath = "misc/nvf-searchix-wrapper.nix";
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
      };
    };

    anubis.instances.searchix = lib.mkIf enableAnubis {
      enable = true;
      settings = {
        TARGET = "http://127.0.0.1:${toString appPort}";
        ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis/mainsite_key".path;
        BIND_NETWORK = "tcp";
        BIND = ":${toString anubisPort}";
      };
    };

    traefik.dynamicConfigOptions.http = lib.mkIf enableTraefik {
      routers.searchix = {
        rule = "Host(`searchix.air1.one`)";
        service = "searchix";
        entryPoints = ["websecure"];
        tls.certResolver = "le";
      };
      services.searchix.loadBalancer.servers = [
        {url = "http://127.0.0.1:${toString traefikTarget}";}
      ];
    };
  };
}
