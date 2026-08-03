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
      availableKernelModules = ["ehci_pci" "ata_piix" "megaraid_sas" "xhci_pci" "usbhid" "sd_mod" "sr_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    supportedFilesystems = ["zfs"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/50ffb82c-63de-49d4-a31c-139d31129894";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/0846-19B5";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/home" = {
      device = "tank_safe/home";
      fsType = "zfs";
    };

    "/data/documents" = {
      device = "tank_safe/documents";
      fsType = "zfs";
    };

    "/data/media" = {
      device = "tank_safe/media";
      fsType = "zfs";
    };
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
