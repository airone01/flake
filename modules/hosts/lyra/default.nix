{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.lyra = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.lyraConfig];
  };
}
