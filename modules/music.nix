_: {
  flake.nixosModules.music = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.music =
      lib.mkEnableOption "music softwares";

    config = lib.mkIf config.stars.music {
      environment.systemPackages = with pkgs; [
        mixxx
      ];
    };
  };
}
