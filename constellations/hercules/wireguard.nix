{ config, ... }: {
  # Import the wireguard star
  imports = [
    ../../stars/net/wireguard.nix
  ];

  # Configuration
  stars.wireguard = {
    enable = true;
    role = "server";
    privateKeyFile = config.sops.secrets."wireguard/hercules/private".path;
    publicKey = "/f2YhBklUxg7Jhs8E+0ak60GNDC8mpKDNwTaNu9eaG4=";
    listenPort = 51820;
    
    # Cetus as a peer
    peers = [
      {
        publicKey = "nXFAgYHgGG0Duft3WK2Aw+JhaDO76RJ4PcTg+Dy21QE=";
        allowedIPs = ["10.100.0.2/32"];
        # No endpoint needed for client
      }
    ];
    
    # Ports to forward
    forwardPorts = [
      # Example: Forward Gitea from Hercules to Cetus
      {
        from = 3001;
        to = 3001;
        address = "10.100.0.2"; # Cetus internal VPN IP
      }
      # Add more forwarded ports as needed
    ];
  };

  # Define the secret for WireGuard private key
  sops.secrets."wireguard/hercules/private" = {
    owner = "root";
    group = "root";
    mode = "0400";
    sopsFile = ../../secrets/wireguard.yaml;
  };
  
  # Update firewall rules to open WireGuard port
  networking.firewall.allowedUDPPorts = [ 51820 ];
}
