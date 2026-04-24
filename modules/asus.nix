# feature: ASUS vendor patches
_: {
  flake.nixosModules.asusPatch = {
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
