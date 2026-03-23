# feature: end to end configuration checks
#
# This check emulates the server configurations environment and test services
# connecting between each other.
# Depending on how Hercules CI handles KVM, this one test might tank perfs.
# If so, passing `/dev/kvm` to the CI runner might be a solution.
{self, ...}: {
  perSystem = {pkgs, ...}: {
    checks = {
      srv-proxy-chain-e2e = pkgs.testers.runNixOSTest {
        name = "srv-proxy-chain-e2e";

        nodes.server = {
          pkgs,
          lib,
          ...
        }: {
          imports = [
            self.nixosModules.gitea
            self.nixosModules.searchix
            self.nixosModules.anubis
            self.nixosModules.traefik
          ];

          # Mock sops schema as we can't import sops
          options.sops.secrets = lib.mkOption {
            type = lib.types.attrs;
            default = {};
          };

          config = {
            stars.server = {
              gitea.enable = true;
              searchix.enable = true;
              anubis.enable = true;
              traefik.enable = true;
            };

            # Mapping to mock network
            networking.hosts = {
              "127.0.0.1" = ["git.air1.one" "searchix.air1.one" "air1.one"];
            };

            # Disable Searchix scraping
            services.searchix.settings.importer.sources = lib.mkForce {};

            # Mocks
            sops.secrets."gitea/db_password".path =
              lib.mkForce "${pkgs.writeText "dummy-db-pass" "testpassword123"}";
            sops.secrets."anubis/mainsite_key".path =
              lib.mkForce "${pkgs.writeText "dummy-anubis-key" "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"}";
          };
        };

        testScript = ''
          server.start()

          server.wait_for_unit("postgresql.service")
          server.wait_for_unit("gitea.service")
          server.wait_for_unit("searchix.service")

          server.wait_for_unit("anubis-git.service")
          server.wait_for_unit("anubis-searchix.service")
          server.wait_for_unit("traefik.service")

          server.wait_for_open_port(3001)  # Gitea
          server.wait_for_open_port(51313) # Searchix

          server.wait_for_open_port(3031) # Anubis -> Gitea
          server.wait_for_open_port(3033) # Anubis -> Searchix

          server.wait_for_open_port(80)

          with subtest("Traefik issues HTTP to HTTPS redirects"):
              traefik_resp = server.succeed("curl -s -o /dev/null -w '%{http_code}' -H 'Host: git.air1.one' http://127.0.0.1/")
              assert traefik_resp.strip() in ["301", "302", "307", "308"], f"Traefik did not redirect, returned {traefik_resp}"

          with subtest("Anubis successfully routes to Gitea"):
              gitea_resp = server.succeed("curl -s -o /dev/null -w '%{http_code}' -H 'Host: git.air1.one' -H 'X-Real-Ip: 127.0.0.1' http://127.0.0.1:3031/")
              assert gitea_resp.strip() == "200", f"Anubis->Gitea failed, returned HTTP {gitea_resp}"

          with subtest("Anubis successfully routes to Searchix"):
              searchix_resp = server.succeed("curl -s -o /dev/null -w '%{http_code}' -H 'Host: searchix.air1.one' -H 'X-Real-Ip: 127.0.0.1' http://127.0.0.1:3033/")
              assert searchix_resp.strip() in ["200", "404"], f"Anubis->Searchix failed, returned HTTP {searchix_resp}"
        '';
      };
    };
  };
}
