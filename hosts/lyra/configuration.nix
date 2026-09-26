{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../common/desktop.nix
    ../../common/dev.nix
    ../../mods/desktop/noctalia.nix
    ../../mods/desktop/wallpapers.nix
    ../../mods/sys/vpn.nix
    ../../mods/hardware/dualsense.nix
    ../../mods/hardware/flipper.nix
    ../../mods/desktop/gaming.nix
    ../../mods/desktop/nvim.nix
    ../../mods/sys/pretty-boot.nix
    ../../mods/sys/virt.nix
  ];

  programs.niri.package = pkgs.callPackage ../../pkgs/niri {
    inherit inputs;
    noctalia = pkgs.callPackage ../../pkgs/noctalia {inherit inputs;};
    ratePatch = true;
  };

  networking.hostName = "lyra";
  system.stateVersion = "25.11"; # never change this
  time.timeZone = "Europe/Paris";

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
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd niri-session";
        user = "greeter";
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["ntsync"];
  };

  environment.systemPackages = with pkgs; [
    clinfo # to check opencl
    lact # see above
  ];

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev"; # "nodev" for UEFI
      theme = pkgs.minimal-grub-theme;
    };
    efi.canTouchEfiVariables = true;
  };
}
