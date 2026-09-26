# feature: desktop environment
{
  lib,
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
  };
  environment.systemPackages = with pkgs; [
    firefox
    kitty
    localsend
    mc # midnight commander
    ncspot # spotify
    obsidian
    pfetch
    qbittorrent
    ranger
    spotify
    switcheroo
    (symlinkJoin {
      name = "vesktop";
      paths = [vesktop];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/vesktop \
          --add-flags "--disable-features=WebRTCPipeWireCapturerDmaBuf"
      '';
    })
    vlc
  ];

  fonts = {
    packages = with pkgs; [
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

    fontconfig.defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["ShureTechMono Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # Lower nix processes priority for desktops
  nix = {
    daemonIOSchedClass = "idle";
    daemonCPUSchedPolicy = "idle";
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "obsidian"
      "spotify"
    ];

  services = {
    resolved.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # This is required to be explicitly set to false
    pulseaudio.enable = false;

    # TODO: check that this is useful and should be defined here
    udev.enable = true;
  };

  networking.networkmanager.enable = true;

  hardware.graphics.enable = true;

  programs = {
    localsend.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-gstreamer
        obs-vaapi
      ];
    };

    firefox = {
      enable = true;
      languagePacks = ["en-US" "fr"];
    };

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-volman
        thunar-shares-plugin
        thunar-archive-plugin
      ];
    };
  };
}
