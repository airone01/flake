_: {
  flake.nixosModules.gitea = {
    lib,
    config,
    ...
  }: {
    options.stars.server.gitea.enable =
      lib.mkEnableOption "Gitea, a git forge";

    config = lib.mkIf config.stars.server.gitea.enable {
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
          sopsFile = ../../secrets/gitea.yaml;
        };
      };

      services.traefik.dynamicConfigOptions.http = {
        routers.gitea = {
          rule = "Host(`git.air1.one`)";
          service = "gitea";
          entryPoints = ["websecure"];
          tls.certResolver = "le";
        };
        services.gitea.loadBalancer.servers = [
          {url = "http://127.0.0.1:3001";}
        ];
      };
    };
  };
}
