{ config, ... }: {
  # Import the wireguard star
  imports = [
    ../../stars/net/wireguard.nix
  ];

  # Configuration
  stars.wireguard = {
    enable = true;
    role = "client";
    privateKeyFile = config.sops.secrets."wireguard/cetus/private".path;
    publicKey = "nXFAgYHgGG0Duft3WK2Aw+JhaDO76RJ4PcTg+Dy21QE=";
    
    # Server details
    serverPublicKey = "/f2YhBklUxg7Jhs8E+0ak60GNDC8mpKDNwTaNu9eaG4=";
    serverEndpoint = "84.235.228.86:51820";
    clientAddress = "10.100.0.2/24";
    
    # Ports to forward (if any)
    forwardPorts = [
      # Example: Forward a local service to Hercules
      {
        from = 8080;
        to = 8080;
        # No address means forward to the local machine
      }
      # Add more forwarded ports as needed
    ];
  };

  # Define the secret for WireGuard private key
  sops.secrets."wireguard/cetus/private" = {
    owner = "root";
    group = "root";
    mode = "0400";
    sopsFile = ../../secrets/wireguard.yaml;
  };
}

