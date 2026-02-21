{
  config,
  lib,
  ...
}: let
  cfg = config.stars.server.ssh-server;
  scfg = config.stars.server.enable;
in {
  options.stars.server.ssh-known-hosts = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          hostNames = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "List of host names and IP addresses for this host.";
          };
          publicKey = lib.mkOption {
            type = lib.types.str;
            description = "Public host key.";
          };
          publicKeyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Path to the public host key file.";
          };
          certAuthority = lib.mkOption {
            default = false;
            type = lib.types.bool;
            description = "Whether this key is a certificate authority.";
          };
          extraHostNames = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Additional host names for this host.";
          };
        };
      });
      default = {};
      description = "Known hosts configuration.";
    };

    enableSystemWideKnownHosts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to configure the known hosts system-wide.";
    };
  };

  config = lib.mkIf (scfg && cfg.enable) {
    # configure system-wide known hosts
    programs.ssh.knownHosts =
      lib.mkIf config.stars.server.ssh-known-hosts.enableSystemWideKnownHosts
      config.stars.server.ssh-known-hosts.hosts;
  };
}
