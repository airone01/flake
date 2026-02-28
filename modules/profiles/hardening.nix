{
  lib,
  config,
  ...
}: let
  cfg = config.stars;
in {
  options.stars.profiles.virt.enable = lib.mkOption {
    default = true;
    example = false;
    description = "Whether to enable security hardening.";
    type = lib.types.bool;
  };

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.virt.enable
    ) {
      networking.firewall.enable = true;
    };
}
