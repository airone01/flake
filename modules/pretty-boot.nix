_: {
  flake.nixosModules.prettyBoot = {
    lib,
    config,
    ...
  }: {
    options.stars.prettyBoot = lib.mkEnableOption "prettier boot sequence";

    config = lib.mkIf config.stars.prettyBoot {
      boot = {
        initrd.systemd.enable = true;
        kernelParams = [
          "quiet"
          "plymouth.use-simpledrm"
        ];
        plymouth = {
          enable = true;
          theme = "bgrt";
        };
      };
    };
  };
}
