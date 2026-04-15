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

      self.nixosModules.caelestia
      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.niri
      self.nixosModules.dev
      self.nixosModules.gaming
      self.nixosModules.prettyBoot
      self.nixosModules.nvim
      self.nixosModules.virt
      self.nixosModules.wallpapers

      self.nixosModules.cassiopeiaHardware
    ];

    networking.hostName = "cassiopeia";
    system.stateVersion = "25.05"; # never change this
    time.timeZone = "Europe/Paris";

    stars = {
      mainUser = "r1";

      core = true;
      desktop = {
        enable = true;
        # hyprland.enable = true;
        niri = {
          enable = true;
          keyboardLayout = "us";
        };
        caelestia.enable = true;
        frenchPatch = true;
        wallpapers.enable = true;
      };
      asusPatch = true;
      dev = true;
      dualsensePatch = true;
      gaming = true;
      nvim = true;
      prettyBoot = true;
      virt = true;
    };

    services.xserver.videoDrivers = [
      "nvidia"
      "amdgpu"
    ];

    # NVIDIA PRIME setup
    hardware.nvidia = {
      modesetting.enable = true;
      open = false; # might change later

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

      # using stable drivers
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # NVIDIA settings app
      nvidiaSettings = true;
    };

    environment.systemPackages = with pkgs; [
      mesa-demos # NVIDIA settings
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd niri-session";
          user = "greeter";
        };
      };
    };

    home-manager.users.${config.stars.mainUser} = {
      wayland.windowManager.hyprland.settings = {
        input = {
          kb_layout = "fr,us";
          kb_options = "grp:caps_toggle"; # caps lock switches layout
          follow_mouse = 1; # focus follow mouse
        };
      };
    };
  };
}
