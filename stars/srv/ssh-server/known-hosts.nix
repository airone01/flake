{
  config,
  lib,
  ...
}: {
  options.stars.ssh-known-hosts = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          hostNames = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "List of host names and IP addresses for this host";
          };
          publicKey = lib.mkOption {
            type = lib.types.str;
            description = "Public host key";
          };
          publicKeyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Path to the public host key file";
          };
          certAuthority = lib.mkOption {
            default = false;
            type = lib.types.bool;
            description = "Whether this key is a certificate authority";
          };
          extraHostNames = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Additional host names for this host";
          };
        };
      });
      default = {};
      description = "Known hosts configuration";
    };

    enableSystemWideKnownHosts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to configure the known hosts system-wide";
    };
  };

  config = lib.mkIf config.stars.ssh-server.enable {
    # Set up the Wireguard hosts as known hosts for easier access
    stars.ssh-known-hosts.hosts = let
      # Try to read hosts.toml if it exists
      wireguardPath = ../../net/wireguard/hosts.toml;
      hostsTOML =
        if builtins.pathExists wireguardPath
        then builtins.fromTOML (builtins.readFile wireguardPath)
        else {};

      # Extract hosts from Wireguard configuration if present
      wgHosts =
        if hostsTOML ? hosts
        then
          lib.mapAttrs
          (name: host: {
            hostNames =
              [
                name
                "${host.ip_addr}"
              ]
              ++ lib.optional (host ? wireguard && host.wireguard ? addrs && host.wireguard.addrs ? v4)
              "${host.wireguard.addrs.v4}";
            publicKey =
              if host ? ssh_pubkey
              then host.ssh_pubkey
              else "";
          })
          hostsTOML.hosts
        else {};
    in
      lib.filterAttrs (_n: v: v.publicKey != "") wgHosts;

    # Configure system-wide known hosts
    programs.ssh.knownHosts =
      lib.mkIf config.stars.ssh-known-hosts.enableSystemWideKnownHosts
      config.stars.ssh-known-hosts.hosts;
  };
}
