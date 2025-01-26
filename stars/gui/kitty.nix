{pkgs, config, ...}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.kitty.enable = true;
  };
}
