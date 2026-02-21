{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  options.stars.profiles.desktop.emailIntegration =
    lib.mkEnableOption "Personal email configuration";

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.desktop.enable
      && cfg.profiles.desktop.emailIntegration
    ) {
      home-manager.users.${config.stars.mainUser}.home = {
        accounts.email.accounts.main = {
          realName = "Erwann Lagouche";
          address = "popgthyrd@gmail.com";
          flavor = "gmail.com";
          passwordCommand = "${pkgs.cat} ${config.sops.secrets."google_apps/main".path}";
          thunderbird.enable = true;
          primary = true;
        };

        programs = {
          thunderbird = {
            enable = true;
            profiles.main.isDefault = true;
          };
        };
      };

      # even with the following secret defined, the sops config still needs
      # to be set to allow the secret on the wanted host, and the key needs
      # to be updated with `sops updatekeys`
      sops.secrets = {
        "google_apps/main" = {
          owner = config.stars.mainUser;
          mode = "0400";
          sopsFile = ../../secrets/email.yaml;
        };
      };
    };
}
