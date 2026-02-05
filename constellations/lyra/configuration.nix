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

  home-manager.users.${config.stars.mainUser} = {
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
