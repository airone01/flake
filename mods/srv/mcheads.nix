{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  traefikEnabled = config.services.traefik.enable or false;
  mcheadsPkg = pkgs.callPackage ../../pkgs/mcheads {inherit inputs;};
in {
  systemd.services.mcheads = {
    description = "Minecraft Player Heads API";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    serviceConfig = {
      ExecStart = "${mcheadsPkg}/bin/mcheads";
      Restart = "always";
      DynamicUser = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
    };
  };

  services.traefik.dynamicConfigOptions.http = lib.mkIf traefikEnabled {
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
}
