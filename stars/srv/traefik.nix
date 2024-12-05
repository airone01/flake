{pkgs, ...}: {
  name = "traefik";

  config = {config, ...}: {
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

            # Hydra router
            hydra = {
              rule = "Host(`hydra.air1.one`)";
              service = "hydra";
              entryPoints = ["websecure"];
              tls = {};
            };
          };

          services = {
            # Main site service
            mainsite.loadBalancer.servers = [
              {
                url = "http://127.0.0.1:8000";
              }
            ];

            # Hydra service
            hydra.loadBalancer.servers = [
              {
                url = "http://127.0.0.1:3000";
              }
            ];
          };
        };
      };
    };

    # Main website service
    services.nginx = {
      enable = true;
      virtualHosts."_" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 8000;
          }
        ];
        root = pkgs.writeTextDir "index.html" ''
          <h1>Welcome to air1.one.</h1><hr><pre>
          <a href="https://git.air1.one/">Gitea</a>
          <a href="https://hydra.air1.one/">Hydra</a>
          </pre><hr>
        '';
      };
    };

    # Open necessary ports
    networking.firewall.allowedTCPPorts = [80 443 8000 3000];
  };
}
