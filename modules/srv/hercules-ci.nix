{
  lib,
  config,
  ...
}: let
  cfg = config.stars.server.hercules-ci;
  scfg = config.stars.server.enable;
in {
  options.stars.server.hercules-ci.enable =
    lib.mkEnableOption "Hercules CI agent";

  config = lib.mkIf (scfg && cfg.enable) {
    services.hercules-ci-agent = {
      enable = true;
      settings = {
        # # limit concurrency to avoid ram explosion
        # concurrentTasks = 2;

        clusterJoinTokenPath = config.sops.templates."hercules-ci-agent-cluster-join-token.key".path;
        binaryCachesPath = config.sops.templates."hercules-ci-agent-binary-caches.json".path;
      };
    };

    sops.secrets = {
      "clusterJoinToken" = {
        sopsFile = ../../secrets/hercules-ci.yaml;
      };
      "binaryCaches" = {
        sopsFile = ../../secrets/hercules-ci.yaml;
      };
    };

    sops.templates = {
      "hercules-ci-agent-cluster-join-token.key" = {
        content = config.sops.placeholder."clusterJoinToken";
        owner = config.users.users.hercules-ci-agent.name;
        inherit (config.users.users.hercules-ci-agent) group;
        mode = "0400";
      };

      "hercules-ci-agent-binary-caches.json" = {
        content = config.sops.placeholder."binaryCaches";
        owner = config.users.users.hercules-ci-agent.name;
        inherit (config.users.users.hercules-ci-agent) group;
        mode = "0400";
      };
    };
  };
}
