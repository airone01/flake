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
      type = lib.types.listOf lib.types.str;
      default = [ "0.0.0.0" "::" ];
      description = "Addresses on which the SSH server should listen";
      example = [ "192.168.1.1" "10.77.1.1" ];
    };

    ports = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ 22 ];
      description = "Ports on which the SSH server should listen";
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

      settings = {
        PermitRootLogin = cfg.permitRootLogin;
        PasswordAuthentication = cfg.passwordAuthentication;
        KbdInteractiveAuthentication = cfg.passwordAuthentication;
        ListenAddress = cfg.listenAddresses;
        Port = cfg.ports;
      } // lib.optionalAttrs (cfg.allowUsers != []) {
        AllowUsers = cfg.allowUsers;
      } // lib.optionalAttrs (cfg.allowGroups != []) {
        AllowGroups = cfg.allowGroups;
      };

      # Log more verbosely for auth failures
      extraConfig = ''
        LogLevel VERBOSE

        # Privilege separation (ensure it's on in modern OpenSSH)
        UsePrivilegeSeparation sandbox

        # Disable unused features
        Compression no
        AllowAgentForwarding yes
        AllowTcpForwarding yes
        AllowStreamLocalForwarding no

        # Banner and login settings
        Banner none
        PrintMotd no
        PrintLastLog yes

        # Enforce secure ciphers and algorithms
        # (This is managed in hardening.nix)

        ${cfg.extraConfig}
      '';
    };

    # Open SSH ports in the firewall
    networking.firewall.allowedTCPPorts = cfg.ports;

    # Mosh support (if enabled)
    programs.mosh = lib.mkIf cfg.mosh.enable {
      enable = true;
      package = cfg.mosh.package;
    };

    # If mosh is enabled, open its UDP ports
    networking.firewall = lib.mkIf cfg.mosh.enable {
      allowedUDPPortRanges = [ { from = 60000; to = 61000; } ];
    };

    # Add convenient SSH client tools
    environment.systemPackages = with pkgs; [
      openssh
      sshfs
    ] ++ lib.optional cfg.mosh.enable cfg.mosh.package;
  };
}
