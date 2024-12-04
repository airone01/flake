{pkgs, ...}: {
  name = "hydra";

  config = _: {
    # Enable Hydra service
    services.hydra = {
      enable = true;
      hydraURL = "https://hydra.nix.air1.one";
      notificationSender = "hydra@air1.one";

      # Basic Hydra configuration
      buildMachinesFiles = [];
      useSubstitutes = true;

      # Configure Hydra to listen on localhost:3000
      port = 3000;
      listenHost = "127.0.0.1";
    };

    # Hydra needs these
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
      ensureDatabases = ["hydra"];
      ensureUsers = [
        {
          name = "hydra";
          ensureDBOwnership = true;
        }
      ];
    };

    # Required system configuration for Hydra
    nix = {
      settings = {
        allowed-users = ["hydra" "hydra-queue-runner"];
        trusted-users = ["hydra" "hydra-queue-runner"];
        auto-optimise-store = true;
      };
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    # Create hydra user/group
    users.users.hydra = {
      group = "hydra";
      isNormalUser = false;
      isSystemUser = true;
    };
    users.groups.hydra = {};
  };
}
