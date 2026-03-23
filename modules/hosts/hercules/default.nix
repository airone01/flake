{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.hercules = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.herculesConfig];
  };
}
