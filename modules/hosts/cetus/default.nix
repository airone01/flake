{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.cetus = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.cetusConfig];
  };
}
