{config, ...}: {
  services.hercules-ci-agent = {
    enable = true;
    settings = {
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
}
