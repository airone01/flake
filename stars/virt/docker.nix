{config, ...}: {
  virtualisation.docker.enable = true;
  users.users.${config.stars.mainUser}.extraGroups = ["docker"];

  # TODO: switch to podman
  # https://nix-community.github.io/home-manager/options.xhtml#opt-services.podman.package
}
