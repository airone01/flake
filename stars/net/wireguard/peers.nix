{ pkgs, lib, ... }:

let
  # Read and parse the hosts.toml file
  toml = pkgs.formats.toml { };
  metadata = builtins.fromTOML (builtins.readFile ./hosts.toml);

  # Function to generate roaming peer configuration
  roamPeer = host: {
    publicKey = metadata.hosts.${host}.wireguard.pubkey;
    allowedIPs = [
      "${metadata.hosts.${host}.wireguard.addrs.v4}/32"
      "${metadata.common.ula}:${metadata.hosts.${host}.wireguard.addrs.v6}/128"
    ];
  };

  # Function to generate server peer configuration
  serverPeer = host: {
    publicKey = metadata.hosts.${host}.wireguard.pubkey;
    allowedIPs = [
      "${metadata.hosts.${host}.wireguard.addrs.v4}/32"
      "${metadata.common.ula}:${metadata.hosts.${host}.wireguard.addrs.v6}/128"
    ];
    endpoint = "${metadata.hosts.${host}.ip_addr}:${toString metadata.hosts.${host}.wireguard.port}";
    persistentKeepalive = 25;  # Keep connection alive through NAT
  };

  # Define peer lists based on network location
  peerLists = {
    # Peers for cloud hosts
    cloud = [
      (serverPeer "hercules")
      (roamPeer "cetus")
      # Add more peers as needed
    ];

    # Peers for homelab hosts
    homelab = [
      (serverPeer "cetus")
      (roamPeer "hercules")
      # Add more peers as needed
    ];
  };

  # Function to generate Wireguard interface configuration
  interfaceInfo = host: peerList:
    let
      hostData = metadata.hosts.${host};
      wireguardData = hostData.wireguard;
      network = metadata.networks.${hostData.network};
    in {
      ips = [
        "${metadata.common.ula}:${wireguardData.addrs.v6}/128"
        "${wireguardData.addrs.v4}/32"
      ];
      privateKeyFile = "/root/wireguard-keys/private";
      listenPort = wireguardData.port;
      peers = peerList;
    };

  # Host configurations
  hosts = {
    # Cloud hosts
    hercules = interfaceInfo "hercules" peerLists.cloud;

    # Homelab hosts
    cetus = interfaceInfo "cetus" peerLists.homelab;
  };
in {
  inherit metadata hosts;
}
