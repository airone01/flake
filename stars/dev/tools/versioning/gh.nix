{config, ...}: {
  home-manager.users.${config.stars.mainUser}.programs.gh.enable = true;
}
