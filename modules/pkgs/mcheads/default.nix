# feature: MCHeads API package with NixOS checks and modules
{self, ...}: {
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

    checks = {
      mcheads-e2e = pkgs.testers.runNixOSTest {
        name = "mcheads-api-test";

        nodes.server = _: {
          imports = [self.nixosModules.mcheads];
          stars.server.mcheads.enable = true;
        };

        testScript = ''
          server.start()
          server.wait_for_unit("mcheads.service")
          server.wait_for_open_port(8080)

          response = server.succeed("curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/avatar/NonExistentUser123 || true")

          assert response.strip() == "404", f"MCHeads returned {response}"
        '';
      };
    };
  };

  flake.nixosModules.mcheads = {
    lib,
    pkgs,
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

      services.traefik.dynamicConfigOptions.http = lib.mkIf config.stars.server.traefik.enable {
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
