{lib, ...}: {
  # Helper function to lazily load modules
  lazyLoadModule = path: {
    imports = lib.mkLazyModules [path];
  };

  # Cache configuration for commonly used derivations
  mkCachedConfig = {
    config,
    lib,
    pkgs,
    ...
  }: {
    nix = {
      # Enable binary caching
      settings = {
        # Increase parallel downloads
        # max-substituters = 8;
        builders-use-substitutes = true;

        # Cache settings
        keep-derivations = true;
        keep-outputs = true;

        # Garbage collection settings
        auto-optimise-store = true;

        # Binary cache settings
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        # Evaluation caching
        eval-cache = true;
        # eval-cache-ttl = 3600; # 1 hour
      };

      # Optimize build times
      daemonCPUSchedPolicy = "batch";
      daemonIOSchedPriority = 5;

      # GC settings
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Optimization settings
      optimise = {
        automatic = true;
        dates = ["weekly"];
      };
    };

    # Experimental systemd sandboxing for better performance
    systemd = {
      services = {
        nix-daemon = {
          serviceConfig = {
            # CPU scheduling
            CPUSchedulingPolicy = "batch";
            # I/O scheduling
            IOSchedulingClass = "best-effort";
            IOSchedulingPriority = 5;
            # Memory management
            MemoryMax = "8G";
          };
        };
      };
    };
  };

  # Function to create a lazy-loaded star module
  mkLazyStar = name: path: {
    imports = lib.mkLazyModules [path];
    config = {
      # Add any star-specific optimizations here
      nix.settings = {
        # Create star-specific binary cache if needed
        extra-substituters = ["https://star-${name}.cachix.org"];
      };
    };
  };

  # Helper to optimize flake evaluation
  optimizeFlakeEval = {
    # Cache commonly used flake inputs
    nixConfig = {
      extra-experimental-features = [
        "flakes"
        "nix-command"
        "recursive-nix"
      ];

      # Flake-specific caching
      flake-registry = "https://raw.githubusercontent.com/NixOS/flake-registry/master/flake-registry.json";
      keep-derivations = true;
      keep-outputs = true;

      # Concurrent downloads for inputs
      max-substituters = 8;
      connect-timeout = 5;
      stalled-download-timeout = 90;
    };

    # Cached output paths
    outputs = {nixpkgs, ...} @ inputs: let
      # Cache system types
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Cache common packages
      pkgsFor = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [];
        };
    in {
      # Cache package outputs
      packages = forAllSystems (system: let
        pkgs = pkgsFor system;
      in {
        inherit (pkgs) hello ripgrep fd;
      });
    };
  };
}
