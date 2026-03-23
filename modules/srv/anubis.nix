{self, ...}: {
  flake.nixosModules.anubis = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.stars.server.anubis.enable = lib.mkEnableOption "Anubis, an HTTP soul weighter";

    config = lib.mkIf config.stars.server.anubis.enable {
      services = {
        anubis = {
          defaultOptions.settings = {
            OG_PASSTHROUGH = true;
            OG_EXPIRY_TIME = "1h";
            COOKIE_DOMAIN = "air1.one";
            REDIRECT_DOMAINS = "air1.one,git.air1.one,searchix.air1.one";
          };

          instances = {
            mainsite = {
              enable = true;
              settings = {
                TARGET = "http://127.0.0.1:5972";
                ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis/mainsite_key".path;
                BIND_NETWORK = "tcp";
                BIND = ":3032";
              };
            };

            git = {
              enable = true;
              settings = {
                TARGET = "http://127.0.0.1:3001";
                ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis/mainsite_key".path;
                BIND_NETWORK = "tcp";
                BIND = ":3031";
              };
            };

            searchix = {
              enable = true;
              settings = {
                TARGET = "http://127.0.0.1:51313";
                ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis/mainsite_key".path;
                BIND_NETWORK = "tcp";
                BIND = ":3033";
              };
            };
          };
        };

        nginx = {
          enable = true;
          virtualHosts."_" = {
            listen = [
              {
                addr = "127.0.0.1";
                port = 5972;
              }
            ];
            root = self.packages.${pkgs.stdenv.hostPlatform.system}.website;
            locations."/" = {
              extraConfig = ''
                autoindex off;
                try_files $uri $uri/index.html $uri.html =404;
              '';
            };
          };
        };

        traefik.dynamicConfigOptions.http = {
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
      };

      users.users.traefik.extraGroups = ["anubis"];

      sops.secrets."anubis/mainsite_key" = {
        owner = "anubis";
        group = "anubis";
        mode = "0400";
        sopsFile = ../../secrets/anubis.yaml;
      };
    };
  };
}
