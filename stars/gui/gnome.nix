{pkgs, config, ...}: {
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    dconf-editor
    # themes
    flat-remix-gtk
    kora-icon-theme
    # additional software
    themechanger
  ];

  home-manager.users.${config.stars.mainUser} = {
    programs.gnome-shell = {
      enable = true;

      extensions = [
        {package = pkgs.gnomeExtensions.blur-my-shell;}
        {package = pkgs.gnomeExtensions.dash-to-dock;}
        {package = pkgs.gnomeExtensions.appindicator;}
      ];
    };

    home.packages = with pkgs; [
      switcheroo
    ];

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

  security.rtkit.enable = true;

  # Exclude some default GNOME apps
  environment.gnome.excludePackages = with pkgs; [
    epiphany # web browser
    totem # video player
    geary # email client
    gnome-music # music player
  ];

  users.users.${config.stars.mainUser} = {
    extraGroups = ["networkmanager" "video"];
  };

  services = {
    # X11 config
    xserver = {
      enable = true;

      windowManager.xmonad.enable = false;
      desktopManager.gnome.enable = true;
      displayManager.gdm = {
        wayland = false;
        enable = true;
      };
    };

    # UDEV rules
    udev.packages = with pkgs; [gnome-settings-daemon];
    # Patch for GNOME2 applications
    dbus = {
      enable = true;
      packages = with pkgs; [gnome2.GConf];
    };

    # Enable GNOME-specific services
    gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      gnome-settings-daemon.enable = true;
    };
  };
}
