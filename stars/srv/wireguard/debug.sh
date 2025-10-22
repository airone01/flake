#!/usr/bin/env bash
# Wireguard debug script

set -e

export NIXOS_CONFIG_PATH="$USER/.config/nixos"

echo "=== Wireguard Interface Status ==="
ip a show wg0 || echo "wg0 interface not found!"

echo -e "\n=== Wireguard Service Status ==="
systemctl status wireguard-wg0 || true

echo -e "\n=== Wireguard Configuration ==="
wg show || echo "No Wireguard configuration found!"

echo -e "\n=== Checking Private Key ==="
if [ -f /root/wireguard-keys/private ]; then
  echo "Private key exists"
  ls -la /root/wireguard-keys/
else
  echo "Private key file missing!"
fi

echo -e "\n=== Checking Wireguard Service Logs ==="
journalctl -u wireguard-wg0 -n 20 || true

echo -e "\n=== Checking Firewall Status ==="
echo "Wireguard port:"
grep listenPort $NIXOS_CONFIG_PATH/stars/net/wireguard/hosts.toml | grep $(hostname) -A 3 | grep port

echo -e "\nFirewall rules:"
sudo iptables -L -n | grep -i udp

echo -e "\n=== Network Route Table ==="
ip route

echo -e "\n=== Testing connection to peer ==="
if [ "$(hostname)" == "hercules" ]; then
  PEER_IP=$(grep -A 3 "\[hosts.cetus.wireguard\]" $NIXOS_CONFIG_PATH/stars/net/wireguard/hosts.toml | grep "v4" | cut -d'"' -f2)
  echo "Attempting to ping cetus at ${PEER_IP}..."
else
  PEER_IP=$(grep -A 3 "\[hosts.hercules.wireguard\]" $NIXOS_CONFIG_PATH/stars/net/wireguard/hosts.toml | grep "v4" | cut -d'"' -f2)
  echo "Attempting to ping hercules at ${PEER_IP}..."
fi

ping -c 3 -W 2 ${PEER_IP} || echo "Ping failed!"
