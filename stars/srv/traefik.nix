{pkgs, ...}: {
  name = "traefik";

  config = _: {
    # Enable and configure Traefik
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
            http.tls.certResolver = "letsencrypt";
          };
        };

        certificatesResolvers.letsencrypt.acme = {
          email = "21955960+airone01@users.noreply.github.com";
          storage = "/var/lib/traefik/acme.json";

          tlsChallenge = {};
        };

        api = {
          dashboard = true;
          insecure = false;
        };
      };

      dynamicConfigOptions = {
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
              rule = "Host(`hydra.nix.air1.one`)";
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
        # Default host
        listen = [
          {
            addr = "127.0.0.1";
            port = 8000;
          }
        ];
        root = pkgs.writeTextDir "index.html" ''
          <h1>Welcome to air1.one.</h1><hr><pre><a href="../">../</a>
          <a href="hydra.nix.air1.one">Hydra</a>
          </pre><hr>
        '';
      };
    };

    # Open necessary ports
    networking.firewall.allowedTCPPorts = [80 443 8000 3000];
  };
}

