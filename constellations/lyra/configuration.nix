{
  lib,
  pkgs,
  ...
}: {
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
        structuredExtraConfig = with lib.kernel; {
          # --- FileSystems ---
          XFS_FS = lib.mkForce no;
          F2FS_FS = lib.mkForce no;
          JFS_FS = lib.mkForce no;
          OCFS2_FS = lib.mkForce no;

          F2FS_FS_COMPRESSION = lib.mkForce unset;
          F2FS_FS_SECURITY = lib.mkForce unset;
          F2FS_FS_ENCRYPTION = lib.mkForce unset;

          # --- Networking ---
          HAMRADIO = lib.mkForce no;
          CAN = lib.mkForce no;
          NET_9P = lib.mkForce no;

          AX25 = lib.mkForce unset;
          NET_SCH_BPF = lib.mkForce unset;

          # --- Graphics (Aggressive Pruning) ---
          VGA_SWITCHEROO = lib.mkForce no;
          DRM_NOUVEAU = lib.mkForce no;
          DRM_I915 = lib.mkForce no;
          DRM_XE = lib.mkForce no;
          DRM_VMWGFX = lib.mkForce no;
          DRM_GMA500 = lib.mkForce no;
          DRM_MGAG200 = lib.mkForce no;
          DRM_ETNAVIV = lib.mkForce no;
          DRM_HISI_HIBMC = lib.mkForce no;
          DRM_APPLETBDRM = lib.mkForce no;
          DRM_GM12U320 = lib.mkForce no;
          DRM_PANEL_MIPI_DBI = lib.mkForce no;
          DRM_PIXPAPER = lib.mkForce no;
          TINYDRM_HX8357D = lib.mkForce no;
          TINYDRM_ILI9163 = lib.mkForce no;
          TINYDRM_ILI9225 = lib.mkForce no;
          TINYDRM_ILI9341 = lib.mkForce no;
          TINYDRM_ILI9486 = lib.mkForce no;
          TINYDRM_MI0283QT = lib.mkForce no;
          TINYDRM_REPAPER = lib.mkForce no;
          TINYDRM_SHARP_MEMORY = lib.mkForce no;
          DRM_VBOXVIDEO = lib.mkForce no;
          DRM_GUD = lib.mkForce no;
          DRM_ST7571_I2C = lib.mkForce no;
          DRM_ST7586 = lib.mkForce no;
          DRM_ST7735R = lib.mkForce no;
          DRM_SSD130X = lib.mkForce no;

          DRM_I915_GVT = lib.mkForce unset;
          DRM_I915_GVT_KVMGT = lib.mkForce unset;
          DRM_NOUVEAU_SVM = lib.mkForce unset;

          # --- Misc ---
          LOGO = lib.mkForce yes;
          LOGO_LINUX_CLUT224 = lib.mkForce yes;
          SCHED_CLASS_EXT = lib.mkForce no;

          # --- Build & Debug ---
          # DEBUG_INFO = lib.mkForce no;
          # DEBUG_INFO_NONE = lib.mkForce yes;
          #
          # DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT = lib.mkForce unset;
        };
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
