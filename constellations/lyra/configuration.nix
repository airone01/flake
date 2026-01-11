{
  pkgs,
  config,
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

  ### Graphics
  # recommended for AMD GPU
  hardware.graphics.enable32Bit = true;
  # patches low resolution during initramfs boot stage
  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.overdrive.enable = true; # overclocking
  hardware.amdgpu.opencl.enable = true;
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

  home-manager.users.${config.stars.mainUser} = {
    home.packages = with pkgs; [
      blockbench
    ];

    programs.quickshell.enable = true;

    wayland.windowManager.hyprland.settings = {
      monitor = [", highrr, auto, 1"];
      windowrulev2 = [
        # very specific fixes for raylib
        "float, title:(game_test)"
        "size 800 450, title:(game_test)"
        "center, title:(game_test)"
      ];
    };

    programs.obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
      ];
    };
  };

  fileSystems."/mnt/romm" = {
    device = "//192.168.1.142/romm";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/smb-romm"
      "iocharset=utf8"
      "x-systemd.automount"
      "nofail"
      "uid=1000"
      "gid=100"
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
