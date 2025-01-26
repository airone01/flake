{config, ...}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.btop = {
      enable = true;

      settings = {
        color_theme = "horizon";
        update_ms = 200;
      };
    };
  };
}
