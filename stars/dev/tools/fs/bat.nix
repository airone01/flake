{config, ...}: {
  home-manager.users.${config.stars.mainUser}.programs.bat.enable = true;
}
