{config, ...}: {
  name = "matrix";

  config = _: {
    services = {
      matrix-synapse = {
        enable = true;
        settings = {
          server_name = "matrix.air1.one";
          public_baseurl = "https://matrix.air1.one/";

          database = {
            name = "psycopg2";
            args = {
              database = "matrix-synapse";
              user = "matrix-synapse";
              password_file = config.sops.secrets."matrix/db_password".path;
              host = "localhost";
              cp_min = 5;
              cp_max = 10;
            };
          };

          listeners = [
            {
              port = 3003;
              bind_addresses = ["127.0.0.1"];
              type = "http";
              tls = false;
              x_forwarded = true;
              resources = [
                {
                  names = ["client" "federation"];
                  compress = false;
                }
              ];
            }
          ];

          registration_shared_secret_file = config.sops.secrets."matrix/registration_shared_secret".path;
          macaroon_secret_key_file = config.sops.secrets."matrix/macaroon_secret_key".path;
          form_secret_file = config.sops.secrets."matrix/form_secret".path;
          signing_key_path = config.sops.secrets."matrix/signing_key".path;

          enable_registration = false;
          enable_metrics = true;
          report_stats = false;
        };
      };

      postgresql = {
        enable = true;
        ensureDatabases = ["matrix-synapse"];
        ensureUsers = [
          {
            name = "matrix-synapse";
            ensurePermissions."DATABASE matrix-synapse" = "ALL PRIVILEGES";
          }
        ];
      };
    };

    sops.secrets = {
      "matrix/db_password" = {
        owner = "matrix-synapse";
        group = "matrix-synapse";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
      "matrix/registration_shared_secret" = {
        owner = "matrix-synapse";
        group = "matrix-synapse";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
      "matrix/macaroon_secret_key" = {
        owner = "matrix-synapse";
        group = "matrix-synapse";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
      "matrix/form_secret" = {
        owner = "matrix-synapse";
        group = "matrix-synapse";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
      "matrix/signing_key" = {
        owner = "matrix-synapse";
        group = "matrix-synapse";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
    };

    # Add matrix-synapse to traefik config
    services.traefik.dynamicConfigOptions.http = {
      routers.matrix = {
        rule = "Host(`matrix.air1.one`)";
        service = "matrix";
        entryPoints = ["websecure"];
        tls = {};
      };
      services.matrix.loadBalancer.servers = [
        {
          url = "http://127.0.0.1:3003";
        }
      ];
    };
  };
}
