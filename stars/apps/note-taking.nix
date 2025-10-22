{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.obsidian.enable = true;
  };

  environment.systemPackages = with pkgs; [
    obsidian
  ];
}
