_: {
  flake.nixosModules.ios = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.ios =
      lib.mkEnableOption "iOS support";

    config = lib.mkIf config.stars.ios {
      services.usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };

      environment.systemPackages = with pkgs; [libimobiledevice];
    };
  };
}
