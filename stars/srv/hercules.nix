{config, ...}: {
  services.hercules-ci-agent = {
    enable = true;
    settings = {
      cluserJoinTokenPath = config.sops.templates."hercules-ci-agent-cluster-join-token.key".path;
    };
  };

  sops.secrets."hercules-ci/cluser_join_token" = {
    path = "/var/lib/hercules-ci-agent/secrets/cluster-join-token.key";
    sopsFile = ../../secrets/hercules-ci.yaml;
  };

  sops.templates."hercules-ci-agent-cluster-join-token.key" = {
    content = config.sops.placeholder."hercules-ci/cluser_join_token";
    owner = config.users.users.hercules-ci-agent.name;
    group = config.users.users.hercules-ci-agent.group;
    mode = "0400";
  };
}
