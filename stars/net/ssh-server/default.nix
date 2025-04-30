{ config, lib, pkgs, ... }:

let
  cfg = config.stars.ssh-server;
in {
  imports = [
    ./hardening.nix
    ./known-hosts.nix
    ./ssh-keys
  ];

  options.stars.ssh-server = {
    enable = lib.mkEnableOption "Enable SSH server with enhanced configuration";

    permitRootLogin = lib.mkOption {
      type = lib.types.enum [ "yes" "prohibit-password" "forced-commands-only" "no" ];
      default = "prohibit-password";
      description = "Whether and how root can log in via SSH";
    };

    passwordAuthentication = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to allow password authentication";
    };

    listenAddresses = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          addr = lib.mkOption {
            type = lib.types.str;
            description = "IP address to listen on";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 22;
            description = "Port to listen on for this address";
          };
        };
      });
      default = [
        { addr = "0.0.0.0"; port = 22; }
        { addr = "::"; port = 22; }
      ];
      description = "Addresses and ports on which the SSH server should listen";
      example = [
        { addr = "192.168.1.1"; port = 22; }
        { addr = "10.77.1.1"; port = 2222; }
      ];
    };

    ports = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ 22 ];
      description = "Additional ports on which the SSH server should listen (simplified alternative to listenAddresses)";
    };

    banner = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the banner text shown to SSH clients on connect";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "QUIET" "FATAL" "ERROR" "INFO" "VERBOSE" "DEBUG" "DEBUG1" "DEBUG2" "DEBUG3"
      ];
      default = "VERBOSE";
      description = "Logging level of the SSH daemon";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional configuration for sshd_config";
    };

    allowUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of users allowed to connect via SSH";
      example = [ "rack" "admin" ];
    };

    allowGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "wheel" ];
      description = "List of groups allowed to connect via SSH";
    };

    denyUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of users denied SSH access";
    };

    denyGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of groups denied SSH access";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically open firewall ports for the SSH server";
    };

    allowSFTP = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the SFTP subsystem";
    };

    startWhenNeeded = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to start the SSH server on demand (socket activation)";
    };

    mosh = {
      enable = lib.mkEnableOption "Enable Mosh server";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.mosh;
        description = "Mosh package to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Basic SSH server configuration
    services.openssh = {
      enable = true;
      startWhenNeeded = cfg.startWhenNeeded;
      openFirewall = cfg.openFirewall;
      banner = cfg.banner;
      allowSFTP = cfg.allowSFTP;
      ports = cfg.ports;

      # Configure listen addresses
      listenAddresses = cfg.listenAddresses;

      settings = {
        # Authentication settings
        PermitRootLogin = cfg.permitRootLogin;
        PasswordAuthentication = cfg.passwordAuthentication;
        KbdInteractiveAuthentication = cfg.passwordAuthentication;

        # Logging and display settings
        LogLevel = cfg.logLevel;
        PrintMotd = false;
        PrintLastLog = true;

        # Privilege separation and security
        UsePrivilegeSeparation = "sandbox";
        StrictModes = true;

        # Feature settings
        Compression = false;
        X11Forwarding = false;
        AllowAgentForwarding = true;
        AllowTcpForwarding = true;
        GatewayPorts = "no";

        # Disable DNS lookups for connecting clients
        UseDns = false;

        # Access control lists
        AllowUsers = lib.mkIf (cfg.allowUsers != []) cfg.allowUsers;
        AllowGroups = lib.mkIf (cfg.allowGroups != []) cfg.allowGroups;
        DenyUsers = lib.mkIf (cfg.denyUsers != []) cfg.denyUsers;
        DenyGroups = lib.mkIf (cfg.denyGroups != []) cfg.denyGroups;
      };

      # Additional configuration
      extraConfig = cfg.extraConfig;
    };

    # Mosh support (if enabled)
    programs.mosh = lib.mkIf cfg.mosh.enable {
      enable = true;
      package = cfg.mosh.package;
    };

    # If mosh is enabled, open its UDP ports
    networking.firewall.allowedUDPPortRanges = lib.mkIf (cfg.mosh.enable && cfg.openFirewall) [
      { from = 60000; to = 61000; }
    ];

    # Add convenient SSH client tools
    environment.systemPackages = with pkgs; [
      openssh
      sshfs
    ] ++ lib.optional cfg.mosh.enable cfg.mosh.package;
  };
}
