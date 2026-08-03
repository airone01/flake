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
{herculesPublicKey}: {config, ...}: let
  herculesIp = "10.100.0.1";
  cetusIp = "10.100.0.2";
  wgPort = 13231; # non-default port to avoid ISP blocking of 51820
in {
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
          publicKey = herculesPublicKey;
          allowedIPs = ["${herculesIp}/32"];
          endpoint = "${herculesIp}:${toString wgPort}";
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
}
