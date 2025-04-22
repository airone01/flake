{pkgs, config, ...}: {
  networking.hostName = "cassiopeia";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  stars.mainUser = "r1";

  imports = [
    # Asterisms
    ../../asterisms/desktop.nix

    # Additional stars
    #../../stars/boot/plymouth.nix
    ../../stars/game/prismlauncher.nix
    ../../stars/kbd/fr.nix
    ../../stars/virt/qemu.nix

    # Hardware
    ./hardware-configuration.nix
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA PRIME setup
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Specific to this machine
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Using stable drivers
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Nvidia settings app
    nvidiaSettings = true;
  };

  environment.systemPackages = with pkgs; [
    glxinfo # Nvidia settings
  ];
}
