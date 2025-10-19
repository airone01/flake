{
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [
    pipx
    # poetry # or python313Packages.poetry-code
    python314
    python314Packages.pip
  ];
}
