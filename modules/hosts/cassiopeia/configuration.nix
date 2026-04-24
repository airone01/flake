{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.cassiopeiaConfig = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager

      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.niri
      self.nixosModules.dev
      self.nixosModules.gaming
      self.nixosModules.prettyBoot
      self.nixosModules.nvim
      self.nixosModules.virt
      self.nixosModules.wallpapers
      self.nixosModules.noctalia

      self.nixosModules.cassiopeiaHardware
    ];

    networking.hosts = {"127.0.0.1" = ["moggolist.fr" "localhost"];};

    networking.hostName = "cassiopeia";
    system.stateVersion = "25.05"; # never change this
    time.timeZone = "Europe/Paris";

    stars = {
      mainUser = "r1";

      core = true;
      desktop = {
        enable = true;
        niri.enable = true;
        noctalia.enable = true;
        wallpapers.enable = true;
      };
      frenchPatch = true;
      asusPatch = true;
      dev = true;
      dualsensePatch = true;
      gaming = true;
      nvim = true;
      prettyBoot = true;
      virt = true;
    };

    services = {
      resolved.enable = true;

      mullvad-vpn = {
        enable = true;
        enableEarlyBootBlocking = true;
      };

      xserver.videoDrivers = [
        "nvidia"
        "amdgpu"
      ];

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd niri-session";
            user = "greeter";
          };
        };
      };
    };

    hardware = {
      bluetooth.enable = true;

      # NVIDIA PRIME setup
      nvidia = {
        modesetting.enable = true;
        open = false; # might change later

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        # Note: for Cassiopeia, it breaks the power cycle. Do not ever enable.
        powerManagement.enable = false;

        # Specific to this machine
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };

        # using stable drivers
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        # NVIDIA settings app
        nvidiaSettings = true;
      };
    };

    environment.systemPackages = with pkgs; [
      mesa-demos # NVIDIA settings
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
  };
}
