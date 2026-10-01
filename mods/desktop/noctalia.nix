# feature: Noctalia shell package integration
{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.noctalia
  ];
}
