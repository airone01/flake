# Do not modify this file!
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
      kernelModules = [];

      # LUKS
      luks.devices = {
        "luks-e09cac65-3a3d-4e19-9cc6-dcc0a23c66aa".device = "/dev/disk/by-uuid/e09cac65-3a3d-4e19-9cc6-dcc0a23c66aa";
        "luks-dc613ea7-9635-4b56-8434-53c81fb1cc27".device = "/dev/disk/by-uuid/dc613ea7-9635-4b56-8434-53c81fb1cc27";
      };
    };

    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4a99e9ed-576a-4b1d-9379-1b89cfcb8dde";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B0B3-72C4";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/52e67026-aeef-4792-a097-31b1a5eca753";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
