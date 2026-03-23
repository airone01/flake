_: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    packages.mcheads = pkgs.buildGoModule {
      pname = "mcheads";
      version = "0.1.0";

      src = ./.;

      # using stdlib only; vendorHash is null
      vendorHash = null;

      meta = with lib; {
        description = "Simple API to fetch Minecraft player heads";
        license = licenses.mit;
        maintainers = [];
      };
    };
  };

  flake.nixosModules.mcheads = {
    lib,
    pkgs,
    self,
    config,
    ...
  }: {
    options.stars.server.mcheads.enable =
      lib.mkEnableOption "MCHeads, a small service for retrieving Minecraft player's avatars";

    config = lib.mkIf config.stars.server.mcheads.enable {
      systemd.services.mcheads = {
        description = "Minecraft Player Heads API";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        serviceConfig = {
          ExecStart = "${self.packages.${pkgs.stdenv.hostPlatform.system}.mcheads}/bin/mcheads";
          Restart = "always";
          DynamicUser = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
        };
      };

      services.traefik.dynamicConfigOptions.http = {
        routers.mcheads = {
          rule = "Host(`mc.air1.one`)";
          service = "mcheads";
          entryPoints = ["websecure"];
          tls.certResolver = "le";
        };
        services.mcheads.loadBalancer.servers = [
          {url = "http://127.0.0.1:8080";}
        ];
      };
    };
  };
}
