# feature: Noctalia shell package integration
{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = [
    (pkgs.callPackage ../../pkgs/noctalia {inherit inputs;})
  ];
}
