# feature: Vaulwarden password manager configuration
#
# TODO: integrate with Anubis and Traefik
{pkgs, ...}: {
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

  environment.systemPackages = [pkgs.vaultwarden];
  networking.firewall.allowedTCPPorts = [8222];
}
