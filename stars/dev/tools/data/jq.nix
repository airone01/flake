{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [
    jq
  ];
}
