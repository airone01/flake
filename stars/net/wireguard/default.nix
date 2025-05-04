{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.stars.wireguard;
  metadata = pkgs.callPackage ./peers.nix {};
  hostname = config.networking.hostName;
in {
  options.stars.wireguard = {
    enable = lib.mkEnableOption "Enable Wireguard site-to-site VPN";

    interfaceName = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
      description = "Name of the Wireguard interface";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create directory for Wireguard keys
    system.activationScripts.wireguardDirs = ''
      mkdir -p /root/wireguard-keys
      chmod 700 /root/wireguard-keys
    '';

    # Set up the private key - each host only accesses its own key
    sops.secrets."wireguard_private_key" = {
      owner = "root";
      group = "root";
      mode = "0400";
      path = "/root/wireguard-keys/private";
      sopsFile = ../../../secrets/wireguard/${hostname}.yaml;
    };

    # Enable Wireguard
    networking.wireguard.interfaces.${cfg.interfaceName} = {
      # This directly accesses the IPs from the metadata
      ips = metadata.hosts.${hostname}.ips;
      listenPort = metadata.hosts.${hostname}.listenPort;
      privateKeyFile = "/root/wireguard-keys/private";

      peers = metadata.hosts.${hostname}.peers;
    };

    # Open firewall for Wireguard
    networking.firewall = {
      allowedUDPPorts = [(metadata.hosts.${hostname}.listenPort or 51820)];
    };

    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];
  };
}
