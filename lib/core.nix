{
  lib,
  pkgs,
  config,
  ...
}: {
  options.stars = {
    mainUser = lib.mkOption {
      type = lib.types.str;
      description = "Name of the main user";
    };
  };

  config = {
    users.users.${config.stars.mainUser} = {
      # UID > 1000
      isNormalUser = true;
      # Gives sudo access
      extraGroups = ["wheel"];
      # Other groups will be added to the user in the respective stars
    };

    environment.systemPackages = with pkgs; [git wget curl];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";

      users.${config.stars.mainUser} = {
        # Add home-manager configurations for the main user here
        home = {
          username = config.stars.mainUser;
          homeDirectory = "/home/${config.stars.mainUser}";

          # This is dangerous but fuck it
          inherit (config.system) stateVersion;
        };
      };
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
