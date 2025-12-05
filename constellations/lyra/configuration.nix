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
    # ../../stars/de-wm/hyprland.nix

    # Hardware
    ./hardware-configuration.nix
  ];

  ### Graphics
  # recommended for AMD GPU
  hardware.graphics.enable32Bit = true;
  # patches low resolution during initramfs boot stage
  hardware.amdgpu.initrd.enable = true;
  # OpenCL
  hardware.amdgpu.opencl.enable = true;
  # LACT: Linux AMDGPU Controller
  services.lact.enable = true;

  environment.systemPackages = with pkgs; [
    clinfo # to check opencl
    lact # see above
  ];
}
