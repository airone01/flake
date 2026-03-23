_: {
  flake.nixosModules.anubis = {
    lib,
    config,
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

          # This is now populated automatically by their respective modules.
          # instances = {};
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
