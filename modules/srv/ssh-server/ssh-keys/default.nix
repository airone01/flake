{
  config,
  lib,
  ...
}: let
  cfg = config.stars.server.ssh-server;
  hostname = config.networking.hostName;

  # try to import host-specific keys if they exist
  hostKeyFile = ./${hostname}.nix;
  hostKeys =
    if builtins.pathExists hostKeyFile
    then import hostKeyFile
    else {};
in {
  options.stars.server.ssh-keys = {
    hostKeys = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "SSH host keys for this system.";
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
      description = "SSH authorized keys for users.";
    };
  };

  config = lib.mkIf cfg.enable {
    # import host-specific keys if available
    stars.server.ssh-keys = hostKeys;

    # configure SSH host keys
    # the new format uses a list of attribute sets with path and type
    services.openssh.hostKeys =
      lib.mapAttrsToList
      (type: path: {
        inherit path;
        inherit type;
      })
      config.stars.server.ssh-keys.hostKeys;

    # configure SSH authorized keys for users
    users.users =
      lib.mapAttrs
      (_username: keys: {
        openssh.authorizedKeys.keys = keys;
      })
      config.stars.server.ssh-keys.userKeys;
  };
}
