{
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [
    pipx
    # poetry # or python313Packages.poetry-code
    python312Full
    python312Packages.pip
  ];
}
