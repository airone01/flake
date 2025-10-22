{
  inputs,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser} = {
    imports = [
      inputs.nvf.homeManagerModules.default
      ./home
    ];
  };
}
