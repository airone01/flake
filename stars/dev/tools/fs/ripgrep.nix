{config, ...}: {
  home-manager.users.${config.stars.mainUser}.programs.ripgrep.enable = true;
}
