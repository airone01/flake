{pkgs, ...}: {
  networking.hostName = "lyra";
  system.stateVersion = "25.11"; # never change this
  time.timeZone = "Europe/Paris";

  stars.mainUser = "user";

  imports = [
    # Asterisms
    ../../asterisms/desktop.nix

    # Additional stars
    #../../stars/sys/boot/plymouth.nix
    ../../stars/game/all.nix
    ../../stars/de-wm/hyprland.nix
    # ../../stars/r1/stylix.nix

    # Hardware
    ./hardware-configuration.nix
  ];

  hardware = {
    ### Graphics
    # recommended for AMD GPU
    graphics.enable32Bit = true;
    amdgpu = {
      # load amdgpu kernel module resolution during initramfs boot stage
      initrd.enable = true;
      overdrive.enable = true; # overclocking
      opencl.enable = true;
    };
  };
  # LACT: Linux AMDGPU Controller
  services.lact.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  stars.home = {
    home.packages = with pkgs; [
      blockbench
    ];

    wayland.windowManager.hyprland.settings.monitor = [", highrr, auto, 1"];

    programs.obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
      ];
    };
  };

  # fileSystems."/mnt/romm" = {
  #   device = "//192.168.1.142/romm";
  #   fsType = "cifs";
  #   options = [
  #     "credentials=/etc/nixos/smb-romm"
  #     "iocharset=utf8"
  #     "x-systemd.automount"
  #     "nofail"
  #     "uid=1000"
  #     "gid=100"
  #   ];
  # };

  # Some game I play (Arkgnights: Endfield), crashes dwproton. The fix is
  # to load the `ntsync` kernel module.
  # Fix source: https://dawn.wine/dawn-winery/dwproton/issues/3
  # I'm also using Zen as this is a gaming machine. `ntsync` should be built
  # into Zen and hence not require modprobe/kernelModules, but just in case I
  # call it below.
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["ntsync"];

    kernelPatches = [
      {
        name = "zen-r1s-custom-config";
        patch = null;
        extraConfig = ''
          # --- FileSystems ---
          CONFIG_XFS_FS=n
          CONFIG_F2FS_FS=n
          CONFIG_JFS_FS=n
          CONFIG_OCFS2_FS=n

          # --- Networking ---
          CONFIG_HAMRADIO=n
          CONFIG_CAN=n
          CONFIG_NET_9P=n

          # --- Graphics (Aggressive Pruning) ---
          CONFIG_VGA_SWITCHEROO=n
          CONFIG_DRM_NOUVEAU=n
          CONFIG_DRM_I915=n
          CONFIG_DRM_XE=n
          CONFIG_DRM_VMWGFX=n
          CONFIG_DRM_GMA500=n
          CONFIG_DRM_MGAG200=n
          CONFIG_DRM_ETNAVIV=n
          CONFIG_DRM_HISI_HIBMC=n
          CONFIG_DRM_APPLETBDRM=n
          CONFIG_DRM_GM12U320=n
          CONFIG_DRM_PANEL_MIPI_DBI=n
          CONFIG_DRM_PIXPAPER=n
          CONFIG_TINYDRM_HX8357D=n
          CONFIG_TINYDRM_ILI9163=n
          CONFIG_TINYDRM_ILI9225=n
          CONFIG_TINYDRM_ILI9341=n
          CONFIG_TINYDRM_ILI9486=n
          CONFIG_TINYDRM_MI0283QT=n
          CONFIG_TINYDRM_REPAPER=n
          CONFIG_TINYDRM_SHARP_MEMORY=n
          CONFIG_DRM_VBOXVIDEO=n
          CONFIG_DRM_GUD=n
          CONFIG_DRM_ST7571_I2C=n
          CONFIG_DRM_ST7586=n
          CONFIG_DRM_ST7735R=n
          CONFIG_DRM_SSD130X=n

          # --- Misc ---
          CONFIG_LOGO=y
          CONFIG_LOGO_LINUX_CLUT224=y

          # --- Build & Debug ---
          CONFIG_DEBUG_INFO=n
          CONFIG_DEBUG_INFO_NONE=y

          # Note: NixOS might append its own version string after this
          CONFIG_LOCALVERSION="-r1"
        '';
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    clinfo # to check opencl
    lact # see above
    # gaming & emulation
    lutris
    retroarch-full
    retroarch-assets
  ];
}
