{pkgs, ...}: {
  systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.dconf-editor
    # themes
    flat-remix-gtk
    kora-icon-theme
    # additional software
    themechanger
  ];

  homeConfig = _: {
    programs.gnome-shell = {
      enable = true;

      extensions = [
        {package = pkgs.gnomeExtensions.blur-my-shell;}
        {package = pkgs.gnomeExtensions.gsconnect;}
        {package = pkgs.gnomeExtensions.dash-to-dock;}
        {package = pkgs.gnomeExtensions.appindicator;}
        #{package = pkgs.gnomeExtensions.user-themes;}
      ];
    };

    # GTK themes
    gtk = {
      enable = true;

      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat Remix GTK Light";
      };
      iconTheme = {
        package = pkgs.kora-icon-theme;
        name = "Kora";
      };
    };
  };

  config = {config, ...}: {
    security.rtkit.enable = true;

    # Exclude some default GNOME apps
    environment.gnome.excludePackages = with pkgs; [
      epiphany # web browser
      totem # video player
      geary # email client
      gnome-music # music player
    ];

    # Add your user to necessary groups
    users.users.${config.stars.mainUser} = {
      extraGroups = ["networkmanager" "video"];
    };

    services = {
      # Enable the GNOME Desktop Environment
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };

      # UDEV rules
      udev.packages = with pkgs; [gnome.gnome-settings-daemon];
      # Patch for GNOME2 applications
      dbus.packages = with pkgs; [gnome2.GConf];

      # Enable GNOME-specific services
      gnome = {
        gnome-keyring.enable = true;
        gnome-online-accounts.enable = true;
        gnome-settings-daemon.enable = true;
      };

      # Enable Flatpak support (optional, but useful for GNOME users)
      flatpak.enable = true;
    };
  };
}
