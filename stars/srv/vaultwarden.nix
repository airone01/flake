{
  config,
  lib,
  pkgs,
  ...
}: {
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    config = {
      ROCKET_ADDRESS = "10.77.2.1";
      ROCKET_PORT = 8222;
      DOMAIN = "https://vault.air1.one";
      SIGNUPS_ALLOWED = true;
      ADMIN_TOKEN = "$argon2id$v=19$m=65536,t=4,p=1$SE5UaWhvaFJrK0hRRmFLM3dxRUVrdz09$dooYCHvCoGK7HqDmz3vBFv4zOSd9kLPGPv4MrFHsfUE";
      LOG_FILE = "/var/lib/bitwarden_rs/access.log";
    };
  };

  environment.systemPackages = [pkgs.vaultwarden];

  networking.firewall.allowedTCPPorts = [8222];
}
