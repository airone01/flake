{config, lib, ...}: {
  options.stars.wireguard = {
    enable = lib.mkEnableOption "WireGuard VPN";
    
    role = lib.mkOption {
      type = lib.types.enum ["server" "client"];
      description = "Role of this machine in the WireGuard network";
    };
    
    privateKeyFile = lib.mkOption {
      type = lib.types.str;
      description = "Path to the file containing the WireGuard private key";
    };
    
    publicKey = lib.mkOption {
      type = lib.types.str;
      description = "WireGuard public key";
    };
    
    serverPublicKey = lib.mkOption {
      type = lib.types.str;
      description = "Public key of the WireGuard server";
      default = "";
    };
    
    serverEndpoint = lib.mkOption {
      type = lib.types.str;
      description = "Public endpoint of the WireGuard server (IP:Port)";
      default = "";
    };
    
    serverAddress = lib.mkOption {
      type = lib.types.str;
      description = "Internal VPN address of the server";
      default = "10.100.0.1/24";
    };
    
    clientAddress = lib.mkOption {
      type = lib.types.str;
      description = "Internal VPN address of this client";
      default = "";
    };
    
    listenPort = lib.mkOption {
      type = lib.types.int;
      description = "WireGuard listen port";
      default = 51820;
    };
    
    forwardPorts = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          from = lib.mkOption {
            type = lib.types.int;
            description = "Source port";
          };
          to = lib.mkOption {
            type = lib.types.int;
            description = "Destination port";
          };
          address = lib.mkOption {
            type = lib.types.str;
            description = "Destination address";
            default = "";
          };
        };
      });
      description = "List of ports to forward through the VPN";
      default = [];
    };
    
    peers = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          publicKey = lib.mkOption {
            type = lib.types.str;
            description = "Peer's public key";
          };
          allowedIPs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Allowed IP ranges for this peer";
            default = ["10.100.0.0/24"];
          };
          endpoint = lib.mkOption {
            type = lib.types.str;
            description = "Peer's endpoint (IP:Port)";
            default = "";
          };
        };
      });
      description = "WireGuard peers";
      default = [];
    };
  };

  config = lib.mkIf config.stars.wireguard.enable {
    # Basic WireGuard setup
    networking.wireguard.interfaces = {
      wg0 = {
        ips = if config.stars.wireguard.role == "server" 
              then [config.stars.wireguard.serverAddress]
              else [config.stars.wireguard.clientAddress];
              
        listenPort = config.stars.wireguard.listenPort;
        privateKeyFile = config.stars.wireguard.privateKeyFile;
        
        peers = if config.stars.wireguard.role == "server"
                then config.stars.wireguard.peers
                else [{
                  publicKey = config.stars.wireguard.serverPublicKey;
                  allowedIPs = ["10.100.0.0/24"];
                  endpoint = config.stars.wireguard.serverEndpoint;
                  persistentKeepalive = 25;
                }];
      };
    };
    
    # Enable IP forwarding for VPN traffic
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };
    
    # Open firewall for WireGuard and forwarded ports
    networking.firewall = {
      allowedUDPPorts = [config.stars.wireguard.listenPort];
      
      # Add port forwarding rules
      extraCommands = lib.concatMapStrings 
        (port: ''
          # Forward traffic from ${if port.address != "" then port.address else "any source"} port ${toString port.from} to port ${toString port.to}
          iptables -A FORWARD -i wg0 -p tcp --dport ${toString port.to} -j ACCEPT
          iptables -A FORWARD -i wg0 -p udp --dport ${toString port.to} -j ACCEPT
          ${if port.address != "" then "iptables -t nat -A PREROUTING -i wg0 -p tcp --dport ${toString port.from} -j DNAT --to-destination ${port.address}:${toString port.to}"
                                     else "iptables -t nat -A PREROUTING -i wg0 -p tcp --dport ${toString port.from} -j REDIRECT --to-port ${toString port.to}"}
          ${if port.address != "" then "iptables -t nat -A PREROUTING -i wg0 -p udp --dport ${toString port.from} -j DNAT --to-destination ${port.address}:${toString port.to}"
                                     else "iptables -t nat -A PREROUTING -i wg0 -p udp --dport ${toString port.from} -j REDIRECT --to-port ${toString port.to}"}
        '') 
        config.stars.wireguard.forwardPorts;
    };
    
    # Create SOPS secrets for WireGuard keys
    sops.secrets = {
      "wireguard/private" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
  };
}

