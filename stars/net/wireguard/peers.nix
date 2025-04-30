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
      "${metadata.hosts.${host}.wireguard.addrs.v6}/128"
    ];
  };

  # Function to generate server peer configuration
  serverPeer = host: {
    publicKey = metadata.hosts.${host}.wireguard.pubkey;
    allowedIPs = [
      "${metadata.hosts.${host}.wireguard.addrs.v4}/32"
      "${metadata.hosts.${host}.wireguard.addrs.v6}/128"
    ];
    endpoint = "${metadata.hosts.${host}.ip_addr}:${toString metadata.hosts.${host}.wireguard.port}";
    persistentKeepalive = 25;  # Keep connection alive through NAT
  };

  # Define peer lists based on network location
  peerLists = {
    # Peers for cloud hosts
    cloud = [
      (roamPeer "cetus")
    ];

    # Peers for homelab hosts
    homelab = [
      (roamPeer "hercules")
    ];
  };

  # Function to generate Wireguard interface configuration
  interfaceInfo = host:
    let
      hostData = metadata.hosts.${host};
      wireguardData = hostData.wireguard;
      network = metadata.networks.${hostData.network};
      peerList = if hostData.network == "cloud" then peerLists.cloud else peerLists.homelab;
    in {
      ips = [
        "${wireguardData.addrs.v4}/32"
        "${wireguardData.addrs.v6}/128"  # Fixed IPv6 address
      ];
      listenPort = wireguardData.port;
      peers = peerList;
    };

  # Generate host configurations
  hosts = {
    hercules = interfaceInfo "hercules";
    cetus = interfaceInfo "cetus";
  };
in {
  inherit metadata hosts;
}
