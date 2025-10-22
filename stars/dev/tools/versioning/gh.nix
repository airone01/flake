{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.stars.mainUser}.programs.gh.enable = true;

  environment.systemPackages = with pkgs; [gh];
}
