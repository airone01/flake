{pkgs, ...}: {
  name = "phanpy";

  config = _: {
    # Download and unpack Phanpy distribution
    systemd.services.fetch-phanpy = {
      description = "Fetch and unpack Phanpy distribution";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/var/lib/phanpy";
        User = "nginx";
        Group = "nginx";
      };
      script = ''
        # Create directory if it doesn't exist
        mkdir -p /var/lib/phanpy

        # Download and unpack Phanpy
        ${pkgs.curl}/bin/curl -L \
          "https://github.com/cheeaun/phanpy/releases/download/2024.11.22.8f048af/phanpy-dist.tar.gz" \
          -o phanpy.tar.gz
        ${pkgs.gnutar}/bin/tar xzf phanpy.tar.gz
        rm phanpy.tar.gz
      '';
    };

    # Nginx configuration to serve Phanpy
    services.nginx = {
      enable = true;
      virtualHosts."phanpy.air1.one" = {
        root = "/var/lib/phanpy";
        locations."/" = {
          index = "index.html";
          tryFiles = "$uri $uri/ /index.html";
        };
      };
    };

    # Add Phanpy to traefik config
    services.traefik.dynamicConfigOptions.http = {
      routers.phanpy = {
        rule = "Host(`phanpy.air1.one`)";
        service = "phanpy";
        entryPoints = ["websecure"];
        tls = {};
      };
      services.phanpy.loadBalancer.servers = [
        {
          url = "http://127.0.0.1:8001";
        }
      ];
    };

    # Create required directories
    system.activationScripts.phanpy-dirs = ''
      mkdir -p /var/lib/phanpy
      chown nginx:nginx /var/lib/phanpy
    '';
  };
}

