{ config, lib, ... }:

let
  cfg = config.stars.wireguard;
  hostname = config.networking.hostName;
in {
  config = lib.mkIf cfg.enable {
    # Enable IP forwarding globally
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    # Add static routes for the subnets
    networking.localCommands = ''
      # Add the routes for the VPN subnets
      ${if hostname == "hercules" then "ip route add 10.77.2.0/24 dev ${cfg.interfaceName}" else ""}
      ${if hostname == "cetus" then "ip route add 10.77.1.0/24 dev ${cfg.interfaceName}" else ""}
    '';
  };
}
