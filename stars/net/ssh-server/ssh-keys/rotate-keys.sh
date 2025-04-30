#!/usr/bin/env bash
# Script to generate and rotate SSH keys

set -euo pipefail

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Make sure we have an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

HOSTNAME="$1"
SSH_DIR="/etc/ssh"
KEYS_DIR="$(dirname "$(readlink -f "$0")")/ssh-keys"
KEY_FILE="${KEYS_DIR}/${HOSTNAME}.nix"
BACKUP_DIR="${SSH_DIR}/backup_$(date +%Y%m%d%H%M%S)"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup existing keys
echo "Backing up existing keys to $BACKUP_DIR"
cp -a ${SSH_DIR}/ssh_host_* "$BACKUP_DIR/" 2>/dev/null || true

# Generate new host keys
echo "Generating new SSH host keys..."

# Remove old keys
rm -f ${SSH_DIR}/ssh_host_*key*

# Generate new keys
ssh-keygen -t rsa -b 4096 -f ${SSH_DIR}/ssh_host_rsa_key -N "" -C "$HOSTNAME"
ssh-keygen -t ed25519 -f ${SSH_DIR}/ssh_host_ed25519_key -N "" -C "$HOSTNAME"

# Set proper permissions
chmod 600 ${SSH_DIR}/ssh_host_*key
chmod 644 ${SSH_DIR}/ssh_host_*key.pub

# Update the host key file
echo "Updating $KEY_FILE with new keys..."

# Extract public key fingerprints
RSA_FP=$(ssh-keygen -lf ${SSH_DIR}/ssh_host_rsa_key.pub | awk '{print $2}')
ED25519_FP=$(ssh-keygen -lf ${SSH_DIR}/ssh_host_ed25519_key.pub | awk '{print $2}')

# Create or update the key file
cat > "$KEY_FILE" << EOF
{
  # Host-specific SSH key configuration for $HOSTNAME
  # Generated on $(date)
  # Fingerprints:
  #   RSA:     $RSA_FP
  #   ED25519: $ED25519_FP

  hostKeys = {
    # We're using the default NixOS paths
    # "rsa" = "/etc/ssh/ssh_host_rsa_key";
    # "ed25519" = "/etc/ssh/ssh_host_ed25519_key";
  };

  # Extract existing user keys if present
  userKeys = if builtins.pathExists __curPos.file then
    (import __curPos.file).userKeys
  else {
    # Default user keys if none exist yet
$(if [[ "$HOSTNAME" = "cassiopeia" ]]; then
  echo '    r1 = [];'
else
  echo '    rack = [];'
fi)
    root = [];
  };
}
EOF

echo "Host keys rotated and configuration updated."
echo "Remember to add the new public keys to your known_hosts or update the SSH known hosts star."
echo ""
echo "Public keys:"
echo "RSA:     $(cat ${SSH_DIR}/ssh_host_rsa_key.pub)"
echo "ED25519: $(cat ${SSH_DIR}/ssh_host_ed25519_key.pub)"
echo ""
echo "To apply the changes, rebuild your system with: just switch $HOSTNAME"
