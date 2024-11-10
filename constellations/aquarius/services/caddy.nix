{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  # Use a custom build of Caddy compiled with modules
  # See https://github.com/crabdancing/nixos-caddy-with-plugins
  compiledCaddy = inputs.caddy-many.packages.${pkgs.system}.default.withPlugins {
    caddyModules =
      [
        {
          # CloudFlare DNS handler for ACME API
          name = "cloudflare";
          repo = "github.com/caddy-dns/cloudflare";
          version = "89f16b99c18ef49c8bb470a82f895bce01cbaece";
        }
        {
          # Caching which I will implement later
          name = "cache-handler";
          repo = "github.com/caddyserver/cache-handler";
          version = "v0.13.0";
        }
      ]
      ++ (
        # Caddy Layer4 modules
        lib.lists.map (name: {
          inherit name;
          repo = "github.com/mholt/caddy-l4";
          version = "3d22d6da412883875f573ee4ecca3dbb3fdf0fd0";
        }) ["layer4" "modules/l4proxy" "modules/l4tls" "modules/l4proxyprotocol"]
      );
    vendorHash = "sha256-NqfXipChaAGN4v//BgMAP2WmzUJNhu7yU8Cd6QiJYpg=";
  };

  caddyFinal = compiledCaddy.overrideAttrs (oldAttrs: {
    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        mv $out/bin/caddy $out/bin/caddy-original
        cat > $out/bin/caddy <<EOF
        #!/bin/sh
        set -e
        CLOUDFLARE_TOKEN=\$(cat ${config.sops.secrets."net/caddy/cloudflare/token".path})
        export CLOUDFLARE_TOKEN
        exec $out/bin/caddy-original "\$@"
        EOF
        chmod +x $out/bin/caddy
      '';
  });
in {
  # Define the CloudFlare secret
  sops.secrets."net/caddy/cloudflare/token" = {
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
    sopsFile = ../../../secrets/net/caddy.yaml;
  };

  services.caddy = {
    enable = true;

    package = caddyFinal;

    ############ Actual Caddy config ############
    # It's the config hosted on my home server. #
    # More documentation on this will follow,   #
    # and maybe a wiki for all my stuff as well #
    #############################################
    virtualHosts."https://air1.one".extraConfig = ''
      # Tell Caddy to get the use the ACME DNS API of CloudFlare
      tls {
        dns cloudflare {$CLOUDFLARE_TOKEN}
      }

      respond `${builtins.readFile ./static/index.html}`
    '';
  };

  environment.systemPackages = [caddyFinal];
}
