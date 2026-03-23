_: {
  flake.nixosModules.desktopAsusPatch = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.desktop.asusPatch =
      lib.mkEnableOption "Asus computer patches";

    config = lib.mkIf config.stars.desktop.asusPatch {
      environment.systemPackages = with pkgs; [asusctl];

      services.asusd.enable = true;
    };
  };
}
