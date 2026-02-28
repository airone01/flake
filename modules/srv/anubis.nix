{
  lib,
  config,
  ...
}: let
  cfg = config.stars.server.anubis;
  scfg = config.stars.server.enable;

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
  options.stars.server.anubis.enable =
    lib.mkEnableOption "Anubis, an HTTP soul weighter";

  config = lib.mkIf (scfg && cfg.enable) {
    users = {
      users.anubis = {
        isSystemUser = true;
        group = "anubis";
      };
      groups.anubis = {};

      users.traefik.extraGroups = ["anubis"];
    };

    systemd.services = {
      "anubis-mainsite".serviceConfig = sandbox;
      "anubis-git".serviceConfig = sandbox;
      "anubis-searchix".serviceConfig = sandbox;
    };

    services.anubis = {
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

    sops.secrets = {
      "anubis/mainsite_key" = {
        owner = "anubis";
        group = "anubis";
        mode = "0400";
        sopsFile = ../../secrets/anubis.yaml;
      };
    };
  };
}
