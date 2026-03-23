_: {
  flake.nixosModules.desktopAsusPatches = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.desktop.asusPatches =
      lib.mkEnableOption "Asus computer patches";

    config = lib.mkIf config.stars.desktop.asusPatches {
      environment.systemPackages = with pkgs; [asusctl];

      services.asusd.enable = true;
    };
  };
}
