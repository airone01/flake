{pkgs, config, ...}: {
  home-manager.users.${config.stars.mainUser}.programs.thunderbird = {
    enable = true;
    profiles.main.isDefault = true;
  };
}
