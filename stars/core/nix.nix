_: {
  nix = {
    settings = {
      # Parallel operations
      builders-use-substitutes = true;

      # Cache settings
      keep-derivations = true;
      keep-outputs = true;
      auto-optimise-store = true;

      # Binary caches
      substituters = [
        "https://cache.nixos.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      # Evaluation cache
      eval-cache = true;
    };

    # Daemon CPU scheduling
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 5;

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Store optimization
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };

  # Systemd service optimization
  systemd.services.nix-daemon = {
    serviceConfig = {
      CPUSchedulingPolicy = "batch";
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 5;
      MemoryMax = "8G";
    };
  };
}
