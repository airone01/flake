{
  pkgs,
  websitePackage,
  ...
}: {
  sops.secrets."cloudflare/cert" = {
    sopsFile = ../../secrets/cloudflare.yaml;
    owner = "traefik";
    group = "traefik";
    mode = "0400";
  };
  sops.secrets."cloudflare/key" = {
    sopsFile = ../../secrets/cloudflare.yaml;
    owner = "traefik";
    group = "traefik";
    mode = "0400";
  };

  # 443 for HTTPS
  # 80 for HTTP, used by Let's Encrypt to verify ownership
  networking.firewall.allowedTCPPorts = [443 80];

  services = {
    traefik = {
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
        # tls = {
        #   stores.default.defaultCertificate = {
        #     certFile = config.sops.secrets."cloudflare/cert".path;
        #     keyFile = config.sops.secrets."cloudflare/key".path;
        #   };
        # };

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
            # Main site service - routed through Anubis
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

    # Main website service
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

    # It's only here bc I test on my laptop and I need loopback there,
    # so by default I don't set it in the searchix star :-)
    searchix.settings.web.baseURL = "https://searchix.air1.one";
  };
}
