{config, ...}: {
  name = "mastodon";

  config = _: {
    services.mastodon = {
      enable = true;
      localDomain = "m.air1.one";

      smtp = {
        createLocally = false;
        fromAddress = "notifications@m.air1.one";
        host = "smtp.sendgrid.net";
        port = 587;
        authenticate = true;
        user = "apikey";
        passwordFile = config.sops.secrets."mastodon/smtp_password".path;
      };

      database = {
        createLocally = true;
        type = "postgresql";
        passwordFile = config.sops.secrets."mastodon/db_password".path;
      };

      redis = {
        createLocally = true;
      };

      extraConfig = {
        SINGLE_USER_MODE = "true";
        WEB_DOMAIN = "m.air1.one";
        SECRET_KEY_BASE_FILE = config.sops.secrets."mastodon/secret_key_base".path;
        OTP_SECRET_FILE = config.sops.secrets."mastodon/otp_secret".path;
      };
    };

    sops.secrets = {
      "mastodon/db_password" = {
        owner = "mastodon";
        group = "mastodon";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
      "mastodon/smtp_password" = {
        owner = "mastodon";
        group = "mastodon";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
      "mastodon/secret_key_base" = {
        owner = "mastodon";
        group = "mastodon";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
      "mastodon/otp_secret" = {
        owner = "mastodon";
        group = "mastodon";
        mode = "0400";
        sopsFile = ../../secrets/secrets.yaml;
      };
    };

    # Add mastodon to traefik config
    services.traefik.dynamicConfigOptions.http = {
      routers.mastodon = {
        rule = "Host(`m.air1.one`)";
        service = "mastodon";
        entryPoints = ["websecure"];
        tls = {};
      };
      services.mastodon.loadBalancer.servers = [
        {
          url = "http://127.0.0.1:3002";
        }
      ];
    };
  };
}
