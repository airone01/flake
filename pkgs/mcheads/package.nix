# feature: MCHeads API package
{
  lib,
  pkgs,
  ...
}:
pkgs.buildGoModule {
  pname = "mcheads";
  version = "0.1.0";

  src = ./.;

  # using stdlib only; vendorHash is null
  vendorHash = null;

  meta = with lib; {
    description = "Simple API to fetch Minecraft player heads";
    license = licenses.mit;
    maintainers = [];
  };
}
