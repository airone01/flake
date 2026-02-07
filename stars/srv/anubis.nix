{config, ...}: {
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
          PUBLIC_URL = "https://air1.one";
          ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis/mainsite_key".path;
        };
      };

      git = {
        enable = true;
        settings = {
          TARGET = "http://127.0.0.1:3001";
          PUBLIC_URL = "https://git.air1.one";
          ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis/git_key".path;
        };
      };

      searchix = {
        enable = true;
        settings = {
          TARGET = "http://127.0.0.1:51313";
          PUBLIC_URL = "https://searchix.air1.one";
          ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis/searchix_key".path;
        };
      };
    };
  };

  # Define secrets for Anubis instances
  sops.secrets = {
    "anubis/mainsite_key" = {
      owner = "anubis";
      group = "anubis";
      mode = "0400";
      sopsFile = ../../secrets/secrets.yaml;
    };
    "anubis/git_key" = {
      owner = "anubis";
      group = "anubis";
      mode = "0400";
      sopsFile = ../../secrets/secrets.yaml;
    };
    "anubis/searchix_key" = {
      owner = "anubis";
      group = "anubis";
      mode = "0400";
      sopsFile = ../../secrets/secrets.yaml;
    };
  };
}
