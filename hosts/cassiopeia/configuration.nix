{
  pkgs,
  config,
  ...
}: {
  networking.hostName = "cassiopeia";
  system.stateVersion = "25.05"; # never change this
  time.timeZone = "Europe/Paris";

  stars = {
    mainUser = "r1";

    core = {
      enable = true;

      profiles = {
        desktop = {
          enable = true;

          asusPatches = true;
          dualsensePatches = true;
          frenchPatches = true;
        };
        development.enable = true;
        gaming.enable = true;
        virt.enable = true;
      };
    };
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

    # Using stable drivers
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Nvidia settings app
    nvidiaSettings = true;
  };

  environment.systemPackages = with pkgs; [
    mesa-demos # Nvidia settings
  ];

  # services.displayManager.ly = {
  #   enable = true;
  #   settings = {
  #     animate = true;
  #     animation = "colormix";
  #     bigclock = "en";
  #     bigclock_12hr = true;
  #     bigclock_seconds = true;
  #     clear_password = true;
  #     numlock = true;
  #   };
  # };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  stars.home = [
    {
      wayland.windowManager.hyprland.settings = {
        input = {
          kb_layout = "fr,us";
          kb_options = "grp:caps_toggle"; # caps lock switches layout
          follow_mouse = 1; # focus follow mouse
        };
      };
    }
  ];
}
