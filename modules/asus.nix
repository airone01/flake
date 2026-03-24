# feature: Asus computer patches
_: {
  flake.nixosModules.desktopAsusPatch = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.asusPatch =
      lib.mkEnableOption "Asus computer patches";

    config = lib.mkIf config.stars.asusPatch {
      environment.systemPackages = with pkgs; [asusctl];

      services.asusd.enable = true;
    };
  };
}
