{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.stars.server.traefik;
  scfg = config.stars.server.enable;
  websitePackage = inputs.self.packages.${pkgs.system}.astro-website;
in {
  options.stars.server.traefik.enable =
    lib.mkEnableOption "Traefik, a reverse proxy";

  config = lib.mkIf (scfg && cfg.enable) {
    # 80 for HTTP is used by Let's Encrypt to verify ownership
    networking.firewall.allowedTCPPorts = [443 80];

    services = {
      traefik = {
        enable = true;

        # at time of writing, this has been removed
        # will need to be kept up to date to how the traefik options evolve
        # dynamic.dir = "/var/lib/traefik/dynamic";

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
            # LE = Let's Encrypt
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

        dynamicConfigOptions = {
          http = {
            routers = {
              mainsite = {
                rule = "Host(`air1.one`)";
                service = "mainsite";
                entryPoints = ["websecure"];
                tls.certResolver = "le";
              };

              searchix = {
                rule = "Host(`searchix.air1.one`)";
                service = "searchix";
                entryPoints = ["websecure"];
                tls.certResolver = "le";
              };

              gitea = {
                rule = "Host(`git.air1.one`)";
                service = "gitea";
                entryPoints = ["websecure"];
                tls = {};
              };
            };

            services = {
              # main site service - routed through Anubis
              mainsite.loadBalancer.servers = [
                {
                  url = "http://127.0.0.1:3032";
                }
              ];

              searchix.loadBalancer.servers = [
                {
                  url = "http://127.0.0.1:3033";
                }
              ];

              gitea.loadBalancer.servers = [
                {
                  url = "http://127.0.0.1:3031";
                }
              ];
            };
          };
        };
      };

      # main website service
      nginx = {
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
            # 'try_files' ensures 404s work correctly
            extraConfig = ''
              include ${pkgs.nginx}/conf/mime.types;
              autoindex off;
              try_files $uri $uri/index.html $uri.html =404;
            '';
          };
        };
      };

      # it's only here bc I test on my laptop and I need loopback there,
      # so by default I don't set it in the searchix star :-)
      searchix.settings.web.baseURL = "https://searchix.air1.one";
    };
  };
}
