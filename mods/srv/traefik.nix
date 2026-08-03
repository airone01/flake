# feature: Traefik reverse proxy configuration and integration with other services
{
  networking.firewall.allowedTCPPorts = [443 80];

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

      log.level = "DEBUG";

      api = {
        dashboard = true;
        insecure = false;
      };

      certificatesResolvers = {
        le = {
          acme = {
            email = "airone01@proton.me";
            storage = "/var/lib/traefik/acme.json";
            httpChallenge = {
              entryPoint = "web";
            };
          };
        };
      };
    };
  };
}
