{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.stars.mainUser}.programs.bat.enable = true;

  environment.systemPackages = with pkgs; [
    eza
  ];
}
