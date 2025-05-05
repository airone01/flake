{config, ...}: {
  # Most of these settings yanked from @sioodmy's dotfiles
  # https://github.com/sioodmy/dotfiles/blob/d82f7db5080d0ff4d4920a11378e08df365aeeec/system/nix/default.nix

  nix = {
    settings = {
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
      auto-optimise-store = true;
      eval-cache = true;
      warn-dirty = false;

      sandbox = true;
      max-jobs = "auto";
      # continue building derivations if one fails
      keep-going = true;
      log-lines = 20;
      extra-experimental-features = ["flakes" "nix-command" "recursive-nix" "ca-derivations"];

      # Binary caches
      substituters = [
        "https://cache.nixos.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    # gc kills ssds
    gc.automatic = false;

    # Make builds run with low priority so my system stays responsive
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  programs.nh = {
    enable = true;
    flake = "/home/${config.stars.mainUser}/.config/nixos";
  };

  # This makes rebuilds a little faster
  system.switch = {
    enable = false;
    enableNg = true;
  };
}
