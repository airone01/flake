# Anubis Setup for Hercules

This document describes the Anubis AI firewall implementation for the hercules VPS.

## Overview

Anubis is a Web AI Firewall Utility that protects web services from AI scrapers and bots using proof-of-work challenges. It has been configured to protect:

- Main website (air1.one)
- Gitea instance (git.air1.one)
- Searchix instance (searchix.air1.one)

## Architecture

Traffic flow:

```
Internet → Traefik (443) → Anubis (Unix sockets) → Backend services
```

Traefik receives HTTPS requests and routes them through Anubis instances via Unix sockets:

- `unix:/run/anubis/anubis-mainsite.sock` → nginx on http://127.0.0.1:5972
- `unix:/run/anubis/anubis-git.sock` → gitea on http://127.0.0.1:3001
- `unix:/run/anubis/anubis-searchix.sock` → searchix on http://127.0.0.1:51313

## Configuration

### Default Settings

All Anubis instances share these settings:

- **OG_PASSTHROUGH**: `true` (allows Open Graph metadata to pass through)
- **OG_EXPIRY_TIME**: `1h` (Open Graph cache duration)
- **COOKIE_DOMAIN**: `air1.one` (shared cookie domain)
- **REDIRECT_DOMAINS**: `air1.one,git.air1.one,searchix.air1.one` (allowed redirect targets)

### Instance-Specific Configuration

Each service has its own Anubis instance with:

- Dedicated ED25519 private key for signing challenges
- Service-specific PUBLIC_URL
- Target backend service URL

## Required Secrets

Before deploying, you must add three ED25519 private keys to `secrets/secrets.yaml`:

```yaml
anubis:
  mainsite_key: <ED25519_PRIVATE_KEY_HEX>
  git_key: <ED25519_PRIVATE_KEY_HEX>
  searchix_key: <ED25519_PRIVATE_KEY_HEX>
```

### Generating ED25519 Keys

#### Method 1: Using OpenSSL

```bash
# Generate a key and convert to hex
openssl genpkey -algorithm ED25519 -outform DER | tail -c 32 | xxd -p -c 64
```

#### Method 2: Using Anubis

```bash
# If you have anubis installed
anubis -generate-key
```

#### Method 3: Using Python

```bash
python3 << 'EOF'
from cryptography.hazmat.primitives.asymmetric import ed25519
import binascii

private_key = ed25519.Ed25519PrivateKey.generate()
private_bytes = private_key.private_bytes(
    encoding=serialization.Encoding.Raw,
    format=serialization.PrivateFormat.Raw,
    encryption_algorithm=serialization.NoEncryption()
)
print(binascii.hexlify(private_bytes).decode())
EOF
```

### Adding Secrets with sops

```bash
# Edit the secrets file with sops
sops secrets/secrets.yaml

# Add the keys under the anubis section:
anubis:
  mainsite_key: "your_64_character_hex_key_here"
  git_key: "your_64_character_hex_key_here"
  searchix_key: "your_64_character_hex_key_here"
```

## Files Modified

- `stars/srv/anubis.nix` - New Anubis configuration module
- `constellations/hercules/configuration.nix` - Added anubis.nix import
- `stars/srv/traefik.nix` - Updated to route through Anubis Unix sockets
- `stars/srv/gitea.nix` - Removed duplicate Traefik configuration

## Testing

After deployment, verify that:

1. Unix sockets are created:

   ```bash
   ls -la /run/anubis/
   ```

2. Anubis instances are running:

   ```bash
   systemctl status anubis-mainsite.service
   systemctl status anubis-git.service
   systemctl status anubis-searchix.service
   ```

3. Challenge is presented to new visitors:
   ```bash
   curl -I https://air1.one
   ```

## Troubleshooting

### Check Anubis logs

```bash
journalctl -u anubis-mainsite.service -f
journalctl -u anubis-git.service -f
journalctl -u anubis-searchix.service -f
```

### Verify socket permissions

```bash
ls -la /run/anubis/
```

The sockets should be owned by `anubis:anubis`.

### Test backend connectivity

```bash
# Check if backends are reachable
curl http://127.0.0.1:5972
curl http://127.0.0.1:3001
curl http://127.0.0.1:51313
```

## References

- [Anubis GitHub](https://github.com/TecharoHQ/anubis)
- [Anubis Documentation](https://anubis.techaro.lol)
- [NixOS Anubis Module](https://search.nixos.org/options?query=services.anubis)
