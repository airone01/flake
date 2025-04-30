# Variables
hostname := `hostname`
flake_dir := env_var_or_default("FLAKE_DIR", "~/.config/nixos")
flake_url := env_var_or_default("FLAKE_URL", "github:airone01/flake")

# Default recipe to display help
default:
    @just --list

# Build and switch to a new configuration
switch host=hostname *args="": check-dirty
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🔄 Rebuilding system for {{host}}..."
    sudo nixos-rebuild switch --flake {{flake_dir}}#{{host}} {{args}} 2>&1 | tee nixos-switch.log || (
        grep --color error nixos-switch.log && false
    )
    echo "✅ System successfully rebuilt!"

# Build and test configuration without switching
test host=hostname *args="": check-dirty
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🧪 Testing configuration for {{host}}..."
    nixos-rebuild test --flake {{flake_dir}}#{{host}} {{args}} 2>&1 | tee nixos-test.log || (
        grep --color error nixos-test.log && false
    )
    echo "✅ Test build successful!"

# Build an ISO image
iso system="ursamajor" format="install-iso":
    #!/usr/bin/env bash
    set -euo pipefail
    echo "📀 Building {{format}} for {{system}}..."
    nix build {{flake_dir}}#{{system}}-{{format}}
    echo "✅ ISO build complete!"

# Update all flake inputs
update:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "⬆️  Updating flake inputs..."
    nix flake update --flake {{flake_dir}}
    echo "✅ Flake inputs updated!"

# Update specific flake input
update-input input:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "⬆️  Updating {{input}}..."
    nix flake lock {{flake_dir}} --update-input {{input}}
    echo "✅ {{input}} updated!"

# Format all nix files
fmt:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🎨 Formatting nix files..."
    find . -name "*.nix" -exec alejandra {} +
    echo "✅ Formatting complete!"

# Check nix file formatting
fmt-check:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🔍 Checking nix formatting..."
    find . -name "*.nix" -exec alejandra --check {} +
    echo "✅ Format check passed!"

# Run checks on the flake
check:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🔍 Running flake checks..."
    nix flake check {{flake_dir}}
    echo "✅ All checks passed!"

# Clean old generations
clean generations="14d":
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🧹 Cleaning generations older than {{generations}}..."
    sudo nix-collect-garbage --delete-older-than {{generations}}
    sudo /run/current-system/bin/switch-to-configuration switch
    echo "✅ System cleaned!"

# Enter a development shell
develop shell="commitlint":
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🚀 Launching {{shell}} development environment..."
    nix develop {{flake_dir}}#{{shell}}

# Show the diff of staged nix files
show-diff:
    git diff -U0 *.nix

# Internal recipe to check for dirty git state
[private]
check-dirty:
    #!/usr/bin/env bash
    if [ -n "$(git status --porcelain)" ]; then
        echo "⚠️  Warning: Working directory is dirty. Uncommitted changes may be lost."
        echo "Continue? [y/N]"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Operation cancelled."
            exit 1
        fi
    fi

# Generate an initial SOPS key
sops-key:
    #!/usr/bin/env bash
    set -euo pipefail
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
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🔑 Generating Wireguard keys for {{host}}..."
    mkdir -p secrets/wireguard
    chmod +x ./stars/net/wireguard/generate-keys.sh
    ./stars/net/wireguard/generate-keys.sh {{host}}
    echo "✅ Wireguard keys generated for {{host}}"

# Test Wireguard connection to another host
wg-test peer:
    #!/usr/bin/env bash
    set -euo pipefail
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
    #!/usr/bin/env bash
    set -euo pipefail
    echo "📊 Wireguard Status:"
    sudo wg show

