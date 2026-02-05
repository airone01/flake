{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];

      luks.devices = {
        "cryptroot".device = "/dev/disk/by-uuid/570c8daf-bb57-4962-9b4a-5b057ca8c3b0";
        "crypt_1tb".device = "/dev/disk/by-uuid/58505b05-fe95-48a3-97ec-1811ff6c7e05";
        "crypt_250gb".device = "/dev/disk/by-uuid/8c341c91-7646-41f1-aaa0-6a93e6c22b10";
      };
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/F174-4759";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/data/1tb" = {
      device = "/dev/mapper/crypt_1tb";
      fsType = "ext4";
    };
  };

  fileSystems."/data/250gb" = {
    device = "/dev/mapper/crypt_250gb";
    fsType = "ext4";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
