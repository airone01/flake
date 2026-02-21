{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  imports = [
    ./asus.nix
    ./dualsense.nix
    ./email.nix
    ./firefox.nix
    ./french.nix
    ./gnome.nix
    ./hyprland.nix
  ];

  options.stars.profiles.desktop = {
    enable = lib.mkEnableOption "desktop environment";

    desktopEnv = lib.mkOption {
      default = "hyprland";
      example = "hyprland";
      description = "Which desktop environment to use.";
      type = lib.types.enum ["hyprland" "gnome"];
    };
  };

  config = lib.mkIf (cfg.core.enable && cfg.profiles.desktop.enable) {
    environment.systemPackages = with pkgs; [
      discord
      kitty
      localsend
      mc # midnight commander
      obsidian
      pfetch
      protonvpn-gui
      qFlipper
      qbittorrent
      ranger
      switcheroo
      vlc

      # fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.shure-tech-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
    ];

    fonts.fontconfig.defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["ShureTechMono Nerd Font"];
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "discord"
        "obsidian"
      ];

    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
      # this is required to be explicitly set to false
      pulseaudio.enable = false;

      # TODO: check that this is good
      udev.enable = true;
    };

    networking.networkmanager.enable = true;

    hardware.graphics.enable = true;

    programs.localsend = {
      enable = true;
      openFirewall = true;
    };

    home-manager.users.${config.stars.mainUser} = {
      programs = {
        obs-studio.enable = true;

        obsidian.enable = true;
      };
    };
  };
}
