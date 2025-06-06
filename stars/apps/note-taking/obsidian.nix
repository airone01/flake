{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.stars.mainUser} = {
    # programs.obsidian.enable = true; # Needs newer home-manager

    home.packages = with pkgs; [obsidian];
  };
}
