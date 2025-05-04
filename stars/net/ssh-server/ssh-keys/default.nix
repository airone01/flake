{
  config,
  lib,
  ...
}: let
  cfg = config.stars.ssh-server;
  hostname = config.networking.hostName;

  # Try to import host-specific keys if they exist
  hostKeyFile = ./${hostname}.nix;
  hostKeys =
    if builtins.pathExists hostKeyFile
    then import hostKeyFile
    else {};
in {
  options.stars.ssh-keys = {
    hostKeys = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "SSH host keys for this system";
    };

    userKeys = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = {};
      example = {
        root = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP4ypAXjY8GdBpzG6YhZlFVbGvLRqgwPXmYz7WKu12tJ admin@example.com"
        ];
        alice = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP4ypAXjY8GdBpzG6YhZlFVbGvLRqgwPXmYz7WKu12tJ alice@laptop"
        ];
      };
      description = "SSH authorized keys for users";
    };
  };

  config = lib.mkIf cfg.enable {
    # Import host-specific keys if available
    stars.ssh-keys = hostKeys;

    # Configure SSH host keys
    # The new format uses a list of attribute sets with path and type
    services.openssh.hostKeys =
      lib.mapAttrsToList
      (type: path: {
        inherit path;
        inherit type;
      })
      config.stars.ssh-keys.hostKeys;

    # Configure SSH authorized keys for users
    users.users =
      lib.mapAttrs
      (username: keys: {
        openssh.authorizedKeys.keys = keys;
      })
      config.stars.ssh-keys.userKeys;
  };
}
