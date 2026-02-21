{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  imports = [./schizofox];

  options.stars.profiles.desktop.firefox = {
    enable = lib.mkOption {
      default = true;
      example = true;
      description = "Whether to enable the Firefox web browser.";
      relatedPackages = [pkgs.firefox];
      type = lib.types.bool;
    };

    flavour = lib.mkOption {
      default = "firefox";
      example = "schizofox";
      description = "Which flavour of firefox to use.";
      relatedPackages = [pkgs.firefox];
      type = lib.types.enum ["firefox" "schizofox"];
    };
  };

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.desktop.enable
      && cfg.profiles.desktop.firefox.enable
      && cfg.profiles.desktop.firefox.flavour == "firefox"
    )
    {
      environment.systemPackages = [pkgs.firefox];

      home-manager.users.${config.stars.mainUser}.programs.firefox = {
        enable = true;
        languagePacks = ["en-US" "fr"];
      };
    };
}
