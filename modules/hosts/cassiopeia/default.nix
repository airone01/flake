{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.cassiopeia = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.cassiopeiaConfig];
  };
}
