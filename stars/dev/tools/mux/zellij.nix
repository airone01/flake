{
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.zellij = {
      enable = true;

      settings = {
        show_startup_tips = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [zellij];
}
