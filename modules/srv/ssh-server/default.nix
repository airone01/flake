{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.stars.server.ssh-server;
  scfg = config.stars.server.enable;
in {
  imports = [
    ./hardening.nix
    ./known-hosts.nix
    ./ssh-keys
  ];

  options.stars.server.ssh-server = {
    enable = lib.mkEnableOption "SSH server with enhanced configuration";

    permitRootLogin = lib.mkOption {
      type = lib.types.enum ["yes" "prohibit-password" "forced-commands-only" "no"];
      default = "prohibit-password";
      description = "Whether and how root can log in via SSH.";
    };

    passwordAuthentication = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to allow password authentication.";
    };

    listenAddresses = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          addr = lib.mkOption {
            type = lib.types.str;
            description = "IP address to listen on.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 22;
            description = "Port to listen on for this address.";
          };
        };
      });
      default = [
        {
          addr = "0.0.0.0";
          port = 22;
        }
      ];
      description = "Addresses and ports on which the SSH server should listen.";
      example = [
        {
          addr = "192.168.1.1";
          port = 22;
        }
        {
          addr = "10.77.1.1";
          port = 2222;
        }
      ];
    };

    banner = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the banner text shown to SSH clients on connect.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "QUIET"
        "FATAL"
        "ERROR"
        "INFO"
        "VERBOSE"
        "DEBUG"
        "DEBUG1"
        "DEBUG2"
        "DEBUG3"
      ];
      default = "VERBOSE";
      description = "Logging level of the SSH daemon.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional configuration for sshd_config.";
    };

    allowUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of users allowed to connect via SSH.";
      example = ["rack" "admin"];
    };

    allowGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["wheel"];
      description = "List of groups allowed to connect via SSH.";
    };

    denyUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of users denied SSH access.";
    };

    denyGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of groups denied SSH access.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether tp automatically open firewall ports for the SSH server.";
    };

    allowSFTP = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the SFTP subsystem.";
    };

    startWhenNeeded = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to start the SSH server on demand (socket activation).";
    };

    mosh = {
      enable = lib.mkEnableOption "the Mosh server";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.mosh;
        description = "Mosh package to use.";
      };
    };
  };

  config =
    lib.mkIf (
      scfg && cfg.enable
    ) {
      services.openssh = {
        enable = true;
        inherit (cfg) startWhenNeeded;
        inherit (cfg) openFirewall;
        inherit (cfg) banner;
        inherit (cfg) allowSFTP;
        inherit (cfg) listenAddresses;

        settings = {
          # authentication settings
          PermitRootLogin = cfg.permitRootLogin;
          PasswordAuthentication = cfg.passwordAuthentication;
          KbdInteractiveAuthentication = cfg.passwordAuthentication;

          # logging and display settings
          LogLevel = cfg.logLevel;
          PrintMotd = false;
          PrintLastLog = true;

          # privilege separation and security
          StrictModes = true;

          # feature settings
          Compression = false;
          X11Forwarding = false;
          AllowAgentForwarding = true;
          AllowTcpForwarding = true;
          GatewayPorts = "no";

          # disable DNS lookups for connecting clients
          UseDns = false;

          # access control lists
          AllowUsers = lib.mkIf (cfg.allowUsers != []) cfg.allowUsers;
          AllowGroups = lib.mkIf (cfg.allowGroups != []) cfg.allowGroups;
          DenyUsers = lib.mkIf (cfg.denyUsers != []) cfg.denyUsers;
          DenyGroups = lib.mkIf (cfg.denyGroups != []) cfg.denyGroups;
        };

        # additional configuration
        inherit (cfg) extraConfig;
      };

      # mosh support (if enabled)
      programs.mosh = lib.mkIf cfg.mosh.enable {
        enable = true;
        inherit (cfg.mosh) package;
      };

      # if mosh is enabled, open its UDP ports
      networking.firewall.allowedUDPPortRanges = lib.mkIf (cfg.mosh.enable && cfg.openFirewall) [
        {
          from = 60000;
          to = 61000;
        }
      ];

      environment.systemPackages = with pkgs;
        [
          sshfs
          kitty # for ssh TERM type
        ]
        ++ lib.optional cfg.mosh.enable cfg.mosh.package;
    };
}
