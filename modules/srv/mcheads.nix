{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars.server.mcheads;
  scfg = config.stars.server.enable;
in {
  options.stars.server.mcheads.enable =
    lib.mkEnableOption "MC Heads API";

  config = lib.mkIf (scfg && cfg.enable) {
    systemd.services.mcheads = {
      description = "Minecraft Player Heads API";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        ExecStart = "${pkgs.mcheads}/bin/mcheads";
        Restart = "always";
        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
      };
    };
  };
}
