# feature: Flipper Zero support
_: {
  flake.nixosModules.fz = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.fz =
      lib.mkEnableOption "Flipper Zero support";

    config = lib.mkIf config.stars.fz {
      environment.systemPackages = with pkgs; [
        qFlipper
      ];

      hardware.flipperzero.enable = true;
    };
  };
}
