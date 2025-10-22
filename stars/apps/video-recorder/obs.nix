{config, ...}: {
  home-manager.users.${config.stars.mainUser}.programs.obs-studio.enable = true;
}
