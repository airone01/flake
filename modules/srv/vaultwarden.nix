{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars.server.vaultwarden;
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
  options.stars.server.vaultwarden.enable =
    lib.mkEnableOption "vaultwarden, a BitWarden password manager server";

  config = lib.mkIf (scfg && cfg.enable) {
    users = {
      users.vaultwarden = {
        isSystemUser = true;
        group = "vaultwarden";
      };
      groups.vaultwarden = {};
    };

    services.vaultwarden = {
      enable = true;
      dbBackend = "sqlite";
      config = {
        ROCKET_ADDRESS = "10.77.2.1";
        ROCKET_PORT = 8222;
        DOMAIN = "https://vault.air1.one";
        SIGNUPS_ALLOWED = true;
        # ADMIN_TOKEN = ""; # TODO: set argon2 pass in sops secrets
        LOG_FILE = "/var/lib/bitwarden_rs/access.log";
      };
    };

    systemd.services.vaultwarden = {
      serviceConfig =
        sandbox
        // {
          StateDirectory = "bitwarden_rs";
        };
    };

    environment.systemPackages = [pkgs.vaultwarden];
    networking.firewall.allowedTCPPorts = [8222];
  };
}
