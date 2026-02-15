{inputs, ...}: {
  stars.home = [
    {
      imports = [
        inputs.nvf.homeManagerModules.default
        ./home
      ];
    }
  ];
}
