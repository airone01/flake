{
  config,
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

  networking.firewall.allowedTCPPorts = [443];

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

        api = {
          dashboard = true;
          insecure = false;
        };
      };

      dynamicConfigOptions = {
        tls = {
          stores.default.defaultCertificate = {
            certFile = config.sops.secrets."cloudflare/cert".path;
            keyFile = config.sops.secrets."cloudflare/key".path;
          };
        };

        http = {
          routers = {
            # Main site router
            mainsite = {
              rule = "Host(`air1.one`)";
              service = "mainsite";
              entryPoints = ["websecure"];
              tls = {};
            };

            searchix = {
              rule = "Host(`searchix.air1.one`)";
              service = "searchix";
              entryPoints = ["websecure"];
              tls = {};
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
                url = "unix:/run/anubis/anubis-mainsite.sock";
              }
            ];

            searchix.loadBalancer.servers = [
              {
                url = "unix:/run/anubis/anubis-searchix.sock";
              }
            ];

            gitea.loadBalancer.servers = [
              {
                url = "unix:/run/anubis/anubis-git.sock";
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
