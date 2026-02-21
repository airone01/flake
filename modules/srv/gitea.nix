{
  lib,
  config,
  ...
}: let
  cfg = config.stars.server.gitea;
  scfg = config.stars.server.enable;
in {
  options.stars.server.gitea.enable =
    lib.mkEnableOption "Gitea, a git forge";

  config = lib.mkIf (scfg && cfg.enable) {
    services = {
      gitea = {
        enable = true;
        appName = "Gitea @ air1.one";

        settings = {
          server = {
            DOMAIN = "git.air1.one";
            ROOT_URL = "https://git.air1.one/";
            HTTP_PORT = 3001;
          };
          service = {
            DISABLE_REGISTRATION = true;
            REQUIRE_SIGNIN_VIEW = true;
          };
          security = {
            PASSWORD_COMPLEXITY = "lower,upper,digit,spec";
            MIN_PASSWORD_LENGTH = 12;
          };
        };

        database = {
          type = "postgres";
          passwordFile = config.sops.secrets."gitea/db_password".path;
        };
      };

      postgresql = {
        enable = true;
        ensureDatabases = ["gitea"];
        ensureUsers = [
          {
            name = "gitea";
            ensureDBOwnership = true;
          }
        ];
      };
    };

    sops.secrets = {
      "gitea/db_password" = {
        owner = "gitea";
        group = "gitea";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
    };
  };
}
