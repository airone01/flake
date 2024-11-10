{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.asterisms;
in {
  imports = [
    ../stars
  ];

  options.asterisms = {
    cli.enable = lib.mkEnableOption "CLI asterism";
    desktopGnome.enable = lib.mkEnableOption "GNOME asterism";
    desktopHypr.enable = lib.mkEnableOption "Hyprland asterism";
  };

  config = lib.mkMerge [
    # CLI and core setup
    (lib.mkIf cfg.cli.enable {
      stars = {
        enable = true;

        personal = {
          enable = true;

          nvim.enable = true;
          git.enable = true;
        };

        code.garnix.enable = true;

        cli = {
          btop.enable = true;
          oh-my-posh.enable = true;
          zsh.enable = true;
        };
      };

      # shell
      programs.zsh.enable = true;
      users.users.r1.shell = pkgs.zsh;
    })
    # GNOME setup
    (lib.mkIf cfg.desktopGnome.enable {
      asterisms.cli.enable = true;

      stars = {
        core.sound.enable = true;

        gui = {
          gnome.enable = true;
          plymouth.enable = true;
        };
      };
    })
    # Hyprland setup
    (lib.mkIf cfg.desktopHypr.enable {
      asterisms.cli.enable = true;

      stars = {
        core = {
          fr.enable = true;
          sound.enable = true;
        };

        gui.hypr.enable = true;
      };
    })
  ];
}
