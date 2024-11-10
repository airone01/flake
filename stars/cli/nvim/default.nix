{inputs, ...}: {
  homeConfig = _: {
    imports = [
      inputs.nvf.homeManagerModules.default
      ./home
    ];
  };
}
