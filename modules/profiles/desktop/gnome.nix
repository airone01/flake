{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.desktop.enable
      && cfg.profiles.desktop.desktopEnv == "gnome"
    )
    {
      environment.systemPackages = with pkgs; [
        gnome-tweaks
        dconf-editor
        themechanger
      ];

      home-manager.users.${config.stars.mainUser}.home = {
        programs.gnome-shell = {
          enable = true;

          extensions = [
            {package = pkgs.gnomeExtensions.blur-my-shell;}
            {package = pkgs.gnomeExtensions.dash-to-dock;}
            {package = pkgs.gnomeExtensions.appindicator;}
          ];
        };

        packages = with pkgs; [
          switcheroo
        ];

        # GTK themes
        gtk = {
          enable = true;

          cursorTheme = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Ice";
          };
          iconTheme = {
            package = pkgs.kora-icon-theme;
            name = "kora";
          };
        };
      };

      security.rtkit.enable = true;

      environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];

      services.gnome = {
        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;

        gnome-keyring.enable = true;
        gnome-settings-daemon.enable = true;
      };

      users.users.${config.stars.mainUser} = {
        extraGroups = ["networkmanager" "video"];
      };

      services = {
        desktopManager.gnome.enable = true;

        # UDEV rules
        udev.packages = with pkgs; [gnome-settings-daemon];

        # patch for GNOME2 applications
        dbus = {
          enable = true;
          packages = with pkgs; [gnome2.GConf];
        };
      };
    };
}
