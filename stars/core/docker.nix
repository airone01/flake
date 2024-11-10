{config, ...}: {
  name = "docker";

  config = _: {
    virtualisation.docker.enable = true;
    users.users.${config.stars.mainUser}.extraGroups = ["docker"];
  };
}
