{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.stars.mainUser}.programs.ripgrep.enable = true;

  environment.systemPackages = with pkgs; [
    ripgrep
  ];
}
