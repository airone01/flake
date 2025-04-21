{pkgs, config, ...}: {
  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [protonvpn-gui];
}
