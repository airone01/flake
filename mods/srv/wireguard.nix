# Site-to-site WireGuard VPN: Hercules (server, Oracle VPS) <-> Cetus (client, home ISP)
#
# Network: 10.100.0.0/24
#   Hercules: 10.100.0.1
#   Cetus:    10.100.0.2
#
# Setup (run once, then commit encrypted output):
#   On each host: wg genkey | tee /tmp/wg.key | wg pubkey
#   sops encrypt the private key into secrets/wireguard-{cetus,hercules}.yaml
#   Update the public key options below in each host's configuration.nix
#   Re-encrypt anubis.yaml for Hercules: sops updatekeys secrets/anubis.yaml
_: {
  flake.nixosModules.wireguard = {
    lib,
    config,
    ...
  }: let
    herculesIp = "10.100.0.1";
    cetusIp = "10.100.0.2";
    wgPort = 13231; # non-default port to avoid ISP blocking of 51820
  in {
    options.stars.server.wireguard = {
      server = {
        enable = lib.mkEnableOption "WireGuard VPN server (Hercules/Oracle VPS)";
        cetusPublicKey = lib.mkOption {
          type = lib.types.str;
          description = "Cetus WireGuard public key (output of: wg pubkey < cetus-priv.key)";
          default = "REPLACE_WITH_CETUS_WG_PUBKEY";
        };
      };
      client = {
        enable = lib.mkEnableOption "WireGuard VPN client (Cetus/home, behind NAT)";
        serverEndpoint = lib.mkOption {
          type = lib.types.str;
          description = "Hercules public IP:port (e.g. 1.2.3.4:51820)";
          default = "REPLACE_WITH_HERCULES_PUBLIC_IP:${toString wgPort}";
        };
        serverPublicKey = lib.mkOption {
          type = lib.types.str;
          description = "Hercules WireGuard public key (output of: wg pubkey < hercules-priv.key)";
          default = "REPLACE_WITH_HERCULES_WG_PUBKEY";
        };
      };
    };

    config = lib.mkMerge [
      (lib.mkIf config.stars.server.wireguard.server.enable {
        networking = {
          firewall.allowedUDPPorts = [wgPort];
          wireguard.interfaces.wg0 = {
            ips = ["${herculesIp}/24"];
            listenPort = wgPort;
            privateKeyFile = config.sops.secrets."wireguard/private_key".path;
            peers = [
              {
                publicKey = config.stars.server.wireguard.server.cetusPublicKey;
                allowedIPs = ["${cetusIp}/32"];
              }
            ];
          };
        };
        sops.secrets."wireguard/private_key" = {
          owner = "root";
          mode = "0400";
          sopsFile = ../../secrets/wireguard-hercules.yaml;
        };
      })

      (lib.mkIf config.stars.server.wireguard.client.enable {
        networking = {
          # Only allow Hercules to reach these ports through the WireGuard interface
          firewall.interfaces.wg0.allowedTCPPorts = [
            3031 # Anubis (gitea)
            3033 # Anubis (searchix)
            8080 # MCHeads
          ];
          wireguard.interfaces.wg0 = {
            ips = ["${cetusIp}/24"];
            privateKeyFile = config.sops.secrets."wireguard/private_key".path;
            peers = [
              {
                publicKey = config.stars.server.wireguard.client.serverPublicKey;
                allowedIPs = ["${herculesIp}/32"];
                endpoint = config.stars.server.wireguard.client.serverEndpoint;
                persistentKeepalive = 25; # keep NAT mapping alive
              }
            ];
          };
        };
        sops.secrets."wireguard/private_key" = {
          owner = "root";
          mode = "0400";
          sopsFile = ../../secrets/wireguard-cetus.yaml;
        };
      })
    ];
  };
}
