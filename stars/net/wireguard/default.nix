{ config, pkgs, lib, ... }:

let
  cfg = config.stars.wireguard;
  metadata = pkgs.callPackage ./peers.nix {};
  hostname = config.networking.hostName;
in {
  options.stars.wireguard = {
    enable = lib.mkEnableOption "Enable Wireguard site-to-site VPN";

    interfaceName = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
      description = "Name of the Wireguard interface";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create directory for Wireguard keys
    system.activationScripts.wireguardDirs = ''
      mkdir -p /root/wireguard-keys
      chmod 700 /root/wireguard-keys
    '';

    # Set up the private key
    sops.secrets."wireguard_private_key" = {
      owner = "root";
      group = "root";
      mode = "0400";
      path = "/root/wireguard-keys/private";
      sopsFile = ../../../secrets/wireguard/${hostname}.yaml;
    };

    # Enable ip forwarding
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    # Enable Wireguard
    networking.wireguard.interfaces.${cfg.interfaceName} = {
      ips = metadata.hosts.${hostname}.ips;
      listenPort = metadata.hosts.${hostname}.listenPort;
      privateKeyFile = "/root/wireguard-keys/private";

      # Configure peers with subnet routing
      peers = if hostname == "cetus" then [
        # Cetus -> Hercules peer config
        {
          # Hercules public key
          publicKey = "/f2YhBklUxg7Jhs8E+0ak60GNDC8mpKDNwTaNu9eaG4=";

          # Allow IPs including the subnet
          allowedIPs = [
            "10.77.1.1/32"
            "10.77.1.0/24"
            "fd7d:76ee:835a:1::1/128"
          ];

          # Endpoint is the public IP of hercules
          endpoint = "84.235.228.86:51820";

          # Keep connection alive (important for NAT traversal)
          persistentKeepalive = 25;
        }
      ] else if hostname == "hercules" then [
        # Hercules -> Cetus peer config
        {
          # Cetus public key
          publicKey = "nXFAgYHgGG0Duft3WK2Aw+JhaDO76RJ4PcTg+Dy21QE=";

          # Allow IPs including the subnet
          allowedIPs = [
            "10.77.2.1/32"
            "10.77.2.0/24"
            "fd7d:76ee:835a:2::1/128"
          ];

          # No endpoint needed as Cetus initiates
          persistentKeepalive = 25;
        }
      ] else [];
    };

    # Add custom routes for subnets (as a safety net)
    networking.localCommands = ''
      # Add static routes for the subnets
      ${if hostname == "hercules" then "ip route add 10.77.2.0/24 dev ${cfg.interfaceName} || true" else ""}
      ${if hostname == "cetus" then "ip route add 10.77.1.0/24 dev ${cfg.interfaceName} || true" else ""}
    '';

    # Open firewall for Wireguard
    networking.firewall = {
      allowedUDPPorts = [(metadata.hosts.${hostname}.listenPort or 51820)];

      # Allow forwarded traffic
      extraCommands = ''
        # Accept forwarded packets
        iptables -A FORWARD -i ${cfg.interfaceName} -j ACCEPT || true
        iptables -A FORWARD -o ${cfg.interfaceName} -j ACCEPT || true

        # NAT
        iptables -t nat -A POSTROUTING -s 10.77.0.0/16 ! -o ${cfg.interfaceName} -j MASQUERADE || true
      '';

      extraStopCommands = ''
        # Clean up rules when stopping firewall
        iptables -D FORWARD -i ${cfg.interfaceName} -j ACCEPT 2>/dev/null || true
        iptables -D FORWARD -o ${cfg.interfaceName} -j ACCEPT 2>/dev/null || true
        iptables -t nat -D POSTROUTING -s 10.77.0.0/16 ! -o ${cfg.interfaceName} -j MASQUERADE 2>/dev/null || true
      '';
    };

    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];
  };
}
