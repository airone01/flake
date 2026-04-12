# feature: unified desktop environment
{self, ...}: {
  flake.nixosModules.desktop = {
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.desktopAsusPatch
      self.nixosModules.desktopDualsensePatch
      self.nixosModules.desktopFrench
      self.nixosModules.desktopGnome
      self.nixosModules.desktopHyprland
    ];

    options.stars.desktop = {
      enable = lib.mkEnableOption "desktop environment";
      ratePatch = lib.mkEnableOption "high rate screen configuration";
    };

    config = lib.mkIf config.stars.desktop.enable {
      environment.systemPackages = with pkgs; [
        discord
        firefox
        kitty
        localsend
        mc # midnight commander
        mullvad-vpn
        obsidian
        pfetch
        protonvpn-gui
        qFlipper
        qbittorrent
        ranger
        switcheroo
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

        # TODO: check that this is useful and should be defined here
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

          firefox = {
            enable = true;
            languagePacks = ["en-US" "fr"];
          };
        };
      };
    };
  };
}
