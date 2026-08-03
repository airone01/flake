{
  enableAnubis ? false,
  enableTraefik ? false,
}: {
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  services = {
    nginx = {
      enable = true;
      virtualHosts."_" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 5972;
          }
        ];
        root = pkgs.callPackage ../../pkgs/website {inherit inputs;};
        locations."/".extraConfig = ''
          autoindex off;
          try_files $uri $uri/index.html $uri.html =404;
        '';
      };
    };

    anubis.instances.mainsite = lib.mkIf enableAnubis {
      enable = true;
      settings = {
        TARGET = "http://127.0.0.1:5972";
        ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis/mainsite_key".path;
        BIND_NETWORK = "tcp";
        BIND = ":3032";
      };
    };

    traefik.dynamicConfigOptions.http = lib.mkIf enableTraefik {
      routers.mainsite = {
        rule = "Host(`air1.one`)";
        service = "mainsite";
        entryPoints = ["websecure"];
        tls.certResolver = "le";
      };
      services.mainsite.loadBalancer.servers = [
        {url = "http://127.0.0.1:3032";}
      ];
    };
  };
}
