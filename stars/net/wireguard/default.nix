{ config, pkgs, lib, ... }:

let
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
    # Enable Wireguard
    networking.wireguard.interfaces.${cfg.interfaceName} =
      metadata.hosts.${hostname} or (
        throw "No Wireguard configuration found for host: ${hostname}"
      );

    # Set up the private key - each host only accesses its own key
    sops.secrets."wireguard_private_key" = {
      owner = "root";
      group = "root";
      mode = "0400";
      path = "/root/wireguard-keys/private";
      sopsFile = ../../secrets/wireguard/${hostname}.yaml;
    };

    # Open firewall for Wireguard
    networking.firewall = {
      allowedUDPPorts = [ (metadata.hosts.${hostname}.listenPort or 51820) ];
    };

    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];
  };
}
