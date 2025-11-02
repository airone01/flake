{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.btop = {
      enable = true;

      settings = {
        update_ms = 1000;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    btop
  ];
}
