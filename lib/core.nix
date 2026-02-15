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

    home = lib.mkOption {
      description = "Alias for the main user's Home Manager configuration";
      type = lib.types.submodule {
        freeformType = lib.types.attrs;
      };
      default = {};
    };
  };

  config = {
    users.users.${config.stars.mainUser} = {
      # UID > 1000
      isNormalUser = true;
      # gives super user access
      extraGroups = ["wheel" "dialout"];
      # other groups are added to the user in the respective stars
    };

    environment.systemPackages = with pkgs; [git wget curl];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";

      users.${config.stars.mainUser} = lib.mkMerge [
        {
          home = {
            username = config.stars.mainUser;
            homeDirectory = "/home/${config.stars.mainUser}";
            inherit (config.system) stateVersion;
          };
        }
        config.stars.home
      ];
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
