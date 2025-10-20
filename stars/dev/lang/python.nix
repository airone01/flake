{
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [
    pipx
    # poetry # or python313Packages.poetry-code
    python313
    python313Packages.pip
  ];
}
