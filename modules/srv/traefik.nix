{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars.server.traefik;
  scfg = config.stars.server.enable;

  anubisCfg = config.stars.server.anubis;
  searchixCfg = config.stars.server.searchix;
  giteaCfg = config.stars.server.gitea;

  websitePackage = pkgs.callPackage ../../packages/astro-website.nix {};

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
  options.stars.server.traefik.enable =
    lib.mkEnableOption "Traefik, a reverse proxy";

  config = lib.mkIf (scfg && cfg.enable) (lib.mkMerge [
    # base Traefik config (always applied if TRaefik is enabled)
    {
      # 80 for HTTP used by Let's Encrypt to verify ownership
      networking.firewall.allowedTCPPorts = [443 80];

      services.traefik = {
        enable = true;
        staticConfigOptions = {
          entryPoints = {
            web = {
              address = ":80";
              http.redirections.entryPoint = {
                to = "websecure";
                scheme = "https";
              };
            };
            websecure = {
              address = ":443";
            };
          };

          log.level = "DEBUG";

          api = {
            dashboard = true;
            insecure = false;
          };

          certificatesResolvers = {
            le = {
              acme = {
                email = "popgthyrd@gmail.com";
                storage = "/var/lib/traefik/acme.json";
                httpChallenge = {
                  entryPoint = "web";
                };
              };
            };
          };
        };
      };

      users = {
        users.traefik = {
          isSystemUser = true;
          group = "traefik";
        };
        groups.traefik = {};
      };

      systemd.services.traefik = {
        serviceConfig =
          sandbox
          // {
            StateDirectory = "traefik";
            # traefik needs to bind to port 80/443
            # so we need network capabilities
            AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          };
      };
    }

    # Main site / Anubis (only if Anubis is enabled)
    (lib.mkIf anubisCfg.enable {
      services.traefik.dynamicConfigOptions.http = {
        routers.mainsite = {
          rule = "Host(`air1.one`)";
          service = "mainsite";
          entryPoints = ["websecure"];
          tls.certResolver = "le";
        };
        services.mainsite.loadBalancer.servers = [
          {url = "http://127.0.0.1:3032";}
        ];
      };

      # The underlying NGINX server for the main site
      services.nginx = {
        enable = true;
        virtualHosts."_" = {
          listen = [
            {
              addr = "127.0.0.1";
              port = 5972;
            }
          ];
          root = websitePackage;
          locations."/" = {
            extraConfig = ''
              include ${pkgs.nginx}/conf/mime.types;
              autoindex off;
              try_files $uri $uri/index.html $uri.html =404;
            '';
          };
        };
      };
    })

    # Searchix
    (lib.mkIf searchixCfg.enable {
      services.traefik.dynamicConfigOptions.http = {
        routers.searchix = {
          rule = "Host(`searchix.air1.one`)";
          service = "searchix";
          entryPoints = ["websecure"];
          tls.certResolver = "le";
        };
        services.searchix.loadBalancer.servers = [
          {url = "http://127.0.0.1:3033";}
        ];
      };

      services.searchix.settings.web.baseURL = "https://searchix.air1.one";
    })

    # Gitea
    (lib.mkIf giteaCfg.enable {
      services.traefik.dynamicConfigOptions.http = {
        routers.gitea = {
          rule = "Host(`git.air1.one`)";
          service = "gitea";
          entryPoints = ["websecure"];
          tls = {};
        };
        services.gitea.loadBalancer.servers = [
          {url = "http://127.0.0.1:3031";}
        ];
      };
    })
  ]);
}
