{
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.eza.enable = true;
  };

  environment.systemPackages = with pkgs; [
    eza
  ];
}
