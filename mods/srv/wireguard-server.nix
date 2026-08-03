{cetusPublicKey}: {config, ...}: let
  herculesIp = "10.100.0.1";
  cetusIp = "10.100.0.2";
  wgPort = 13231; # non-default port to avoid ISP blocking of 51820
in {
  networking = {
    firewall.allowedUDPPorts = [wgPort];
    wireguard.interfaces.wg0 = {
      ips = ["${herculesIp}/24"];
      listenPort = wgPort;
      privateKeyFile = config.sops.secrets."wireguard/private_key".path;
      peers = [
        {
          publicKey = cetusPublicKey;
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
}
