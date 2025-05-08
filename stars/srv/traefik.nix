{
  pkgs,
  config,
  zolaWebsite,
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
            service = "zola-site";
            entryPoints = ["websecure"];
            tls = {};
          };

          hydra = {
            rule = "Host(`hydra.air1.one`)";
            service = "hydra";
            entryPoints = ["websecure"];
            tls = {};
          };

          searchix = {
            rule = "Host(`searchix.air1.one`)";
            service = "searchix";
            entryPoints = ["websecure"];
            tls = {};
          };
        };

        services = {
          # Main site service
          mainsite.loadBalancer.servers = [
            {
              url = "http://127.0.0.1:5972";
            }
          ];

          hydra.loadBalancer.servers = [
            {
              url = "http://127.0.0.1:6430";
            }
          ];

          searchix.loadBalancer.servers = [
            {
              url = "http://127.0.0.1:51313";
            }
          ];
        };
      };
    };
  };

  # Main website service
  # TODO: make a prettier landing page
  services.nginx = {
    enable = true;
    virtualHosts."_" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 5972;
        }
      ];
      # root = config.packages.zola-website;
      root = zolaWebsite;
      locations."/" = {
        extraConfig = ''
          autoindex off;
        '';
      };
      # root = pkgs.writeTextDir "index.html" ''
      #   <h1>Welcome to air1.one.</h1><hr><pre>
      #   <a href="https://git.air1.one/">Gitea</a>
      #   <a href="https://hydra.air1.one/">Hydra</a>
      #   <a href="https://searchix.air1.one/">Searchix</a>
      #   </pre><hr>
      # '';
    };
  };

  # It's only here bc I test on my laptop and I need loopback there,
  # so by default I don't set it in the searchix star :-)
  services.searchix.settings.web.baseURL = "https://searchix.air1.one";
}
