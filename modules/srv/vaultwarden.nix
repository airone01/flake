_: {
  flake.nixosModules.vaultwarden = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.server.vaultwarden.enable =
      lib.mkEnableOption "VaultWarden, a BitWarden password manager server";

    config = lib.mkIf config.stars.server.vaultwarden.enable {
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
    };
  };
}
