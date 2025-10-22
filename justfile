# Variables
hostname := `hostname`
flake_dir := env_var_or_default("FLAKE_DIR", "~/.config/nixos")
flake_url := env_var_or_default("FLAKE_URL", "github:airone01/flake")

# Default recipe to display help
default:
    @just --list

# Build a new configuration
boot host=hostname *args="":
    nh os boot -a -H {{host}} {{flake_dir}} {{args}}

# Build and switch to a new configuration
switch host=hostname *args="":
    nh os switch -a -H {{host}} {{flake_dir}} {{args}}

# Build and test configuration without switching
test host=hostname *args="":
    nh os test -a -H {{host}} {{flake_dir}} {{args}}

# Build an ISO image
iso system="ursamajor" format="iso" *args="":
    nom build {{flake_dir}}#{{system}}-{{format}} {{args}}

# Update one or all flake inputs
update *args="":
    nix flake update --flake {{flake_dir}} {{args}}|& nom

# Format all nix files
fmt:
    find . -name "*.nix" -exec alejandra {} +

# Check nix file formatting
fmt-check:
    find . -name "*.nix" -exec alejandra --check {} +

# Run checks on the flake
check *args="":
    nix flake check --all-systems {{flake_dir}} {{args}}|& nom

# Clean unused derivations with NH
clean:
    nh clean all

# Enter a development shell
develop shell="commitlint" *args="":
    echo "🚀 Launching {{shell}} development environment..."
    nom develop {{flake_dir}}#{{shell}} {{args}}

# Show the diff of staged nix files
show-diff:
    git diff -U0 *.nix

# Generate an initial SOPS key
sops-key:
    #!/usr/bin/env sh
    echo "🔑 Generating SOPS age key..."
    mkdir -p ~/.config/sops/age
    if [ ! -f ~/.config/sops/age/keys.txt ]; then
        age-keygen -o ~/.config/sops/age/keys.txt
        echo "✅ Key generated at ~/.config/sops/age/keys.txt"
    else
        echo "⚠️  Key already exists at ~/.config/sops/age/keys.txt"
    fi

# Generate Wireguard keys for a host
wg-keygen host:
    echo "🔑 Generating Wireguard keys for {{host}}..."
    mkdir -p secrets/wireguard
    chmod +x ./stars/net/wireguard/generate-keys.sh
    ./stars/net/wireguard/generate-keys.sh {{host}}
    echo "✅ Wireguard keys generated for {{host}}"

# Test Wireguard connection to another host
wg-test peer:
    #!/usr/bin/env sh
    echo "🧪 Testing Wireguard connection to {{peer}}..."
    PEER_IP=$(grep -A 2 "\[hosts.{{peer}}.wireguard\]" ./stars/net/wireguard/hosts.toml | grep "v4" | cut -d'"' -f2)
    echo "Attempting to ping ${PEER_IP}..."
    if ping -c 3 ${PEER_IP}; then
        echo "✅ Connection successful!"
    else
        echo "❌ Connection failed!"
    fi

# Show Wireguard status
wg-status:
    echo "📊 Wireguard Status:"
    sudo wg show

# Debug Wireguard setup
wg-debug:
    echo "🔍 Running Wireguard diagnostics..."
    chmod +x ./stars/net/wireguard/debug.sh
    sudo ./stars/net/wireguard/debug.sh

# Rotate SSH host keys
ssh-rotate-keys host:
    echo "🔄 Rotating SSH keys for {{host}}..."
    chmod +x ./stars/net/ssh-server/rotate-keys.sh
    sudo ./stars/net/ssh-server/rotate-keys.sh {{host}}
    echo "✅ SSH keys rotated for {{host}}"

# Add an SSH key to a host
ssh-add-key host user key_file:
    #!/usr/bin/env sh
    echo "🔑 Adding SSH key from {{key_file}} for {{user}} on {{host}}..."
    KEY_FILE="./stars/net/ssh-server/ssh-keys/{{host}}.nix"
    KEY=$(cat {{key_file}})

    # Create a temporary file for the updated keys
    TMP_FILE=$(mktemp)

    # Extract the current keys
    awk -v user="{{user}}" -v key="$KEY" '
      BEGIN { in_user = 0; found = 0; }

      # Match the user section start
      /'"{{user}}"' = \[/ {
        in_user = 1;
        print $0;
        next;
      }

      # If we are in the user section, look for the end
      in_user && /\];/ {
        # If we found the key already, just print the line
        if (found) {
          print $0;
        } else {
          # Otherwise add the key before the closing bracket
          gsub(/\];/, "  \"" key "\"\n];");
          print $0;
        }
        in_user = 0;
        next;
      }

      # Check if key already exists in the section
      in_user && $0 ~ key {
        found = 1;
      }

      # Print all other lines
      { print $0; }
    ' "$KEY_FILE" > "$TMP_FILE"

    # If the key was not found and user section not found, we need to add it
    if ! grep -q "{{user}} = \[" "$TMP_FILE"; then
      awk -v user="{{user}}" -v key="$KEY" '
        /userKeys = {/ {
          print $0;
          print "    " user " = [";
          print "      \"" key "\"";
          print "    ];";
          next;
        }
        { print $0; }
      ' "$KEY_FILE" > "$TMP_FILE"
    fi

    # Replace the original file
    cp "$TMP_FILE" "$KEY_FILE"
    rm "$TMP_FILE"

    echo "✅ SSH key added successfully"
    echo "Remember to rebuild your system with: just switch {{host}}"

# Print SSH configuration for a host
ssh-config host:
    #!/usr/bin/env sh
    echo "📋 SSH configuration for {{host}}:"
    echo ""
    if [[ -f "./stars/net/ssh-server/ssh-keys/{{host}}.nix" ]]; then
      echo "=== AUTHORIZED KEYS ==="
      grep -A 20 "userKeys = {" "./stars/net/ssh-server/ssh-keys/{{host}}.nix" | sed 's/^/  /'
      echo ""
    else
      echo "No SSH key configuration found for {{host}}"
    fi

    if grep -q "stars.ssh-server" "./constellations/{{host}}/configuration.nix"; then
      echo "=== SSH SERVER CONFIGURATION ==="
      grep -A 15 "stars.ssh-server" "./constellations/{{host}}/configuration.nix" | sed 's/^/  /'
    else
      echo "No SSH server configuration found for {{host}}"
    fi

# SSH to a host using Wireguard IP
ssh-wg host:
    IP=$(grep -A 3 "\[hosts.{{host}}.wireguard\]" ./stars/net/wireguard/hosts.toml | grep "v4" | cut -d'"' -f2)
    USER=$(if [[ "{{host}}" == "cassiopeia" ]]; then echo "r1"; else echo "rack"; fi)
    echo "🔌 Connecting to {{host}} (${IP}) as ${USER}..."
    ssh ${USER}@${IP}

