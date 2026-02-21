{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "lyra";
  system.stateVersion = "25.11"; # never change this
  time.timeZone = "Europe/Paris";

  stars = {
    mainUser = "user";

    core = {
      enable = true;
      shellConfig = true;
    };

    profiles = {
      desktop = {
        enable = true;

        dualsensePatches = true;
        hyprRatePatches = true;
      };
      development.enable = true;
      gaming.enable = true;
      virt.enable = true;
    };
  };

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

  # some game I play (Arkgnights: Endfield), crashes dwproton. The fix is
  # to load the `ntsync` kernel module.
  # fix source: https://dawn.wine/dawn-winery/dwproton/issues/3
  # i'm also using Zen as this is a gaming machine. `ntsync` should be built
  # into Zen and hence not require modprobe/kernelModules, but just in case I
  # call it below.
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["ntsync"];
  };

  environment.systemPackages = with pkgs; [
    clinfo # to check opencl
    lact # see above
  ];
}
