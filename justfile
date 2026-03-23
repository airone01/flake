hostname := `hostname`
flake_dir := env_var_or_default("FLAKE_DIR", justfile_directory())

default:
    @just --list

# Build a host configuration and add it to the boot menu
boot host=hostname *args="":
    nh os boot --no-update-lock-file -a -H {{host}} {{flake_dir}} {{args}}

# Build a system derivation to `result/`
build-any-system host=hostname *args="":
    nix build --no-update-lock-file --show-trace {{flake_dir}}#nixosConfigurations.{{host}}.config.system.build.toplevel {{args}}|&nom

# Build and switch to a host configuration
# Should probably only be used without setting the host parameter
# If SSH server sigkill's you out, maybe try using the classic NixOS rebuild command
switch host=hostname *args="":
    nh os switch --no-update-lock-file -a -H {{host}} {{flake_dir}} {{args}}

# Build and test a host configuration without switching
# Used for manually testing a full system
test host=hostname *args="":
    nh os test -a -H {{host}} {{flake_dir}} {{args}}

# Update one or all flake inputs
# This is run daily by a GitHub Actions
update *args="":
    nix flake update --flake {{flake_dir}} {{args}}|& nom

# Run checks on the flake
check *args="":
    nix flake check --all-systems --no-update-lock-file {{flake_dir}} {{args}}|& nom

# Garbage collection
clean:
    nh clean all --keep 10

# Enter a development shell
develop shell="commitlint" *args="":
    nom develop --no-update-lock-file {{flake_dir}}#{{shell}} {{args}}

# Diff staged nix files
git-diff:
    git diff -U0 *.nix

# Diff NixOS closure of the current working tree against a previous commit
# This might take a lot of disk space, don't forget to garbage collect
nix-diff host=hostname base="" target="":
    #!/usr/bin/env bash
    set -euo pipefail

    HOST="{{host}}"
    BASE="{{base}}"
    TARGET="{{target}}"

    if [ -z "$BASE" ]; then
        BASE=$(git merge-base HEAD main 2>/dev/null || git merge-base HEAD origin/main)
        echo "[nix-diff] No base commit provided. Using merge-base with main: $BASE"
    else
        echo "[nix-diff] Using provided base commit: $BASE"
    fi

    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT

    echo "[nix-diff] Building base configuration ($BASE) for $HOST..."
    nix build "git+file://$PWD?rev=$BASE#nixosConfigurations.$HOST.config.system.build.toplevel" -o "$TMP_DIR/result-base" |& nom

    echo "[nix-diff] Building target configuration for $HOST..."
    if [ -z "$TARGET" ]; then
        echo "[nix-diff] No target commit provided. Using current working tree (HEAD + uncommitted changes)."
        nix build ".#nixosConfigurations.$HOST.config.system.build.toplevel" -o "$TMP_DIR/result-target" |& nom
    else
        echo "[nix-diff] Using provided target commit: $TARGET"
        nix build "git+file://$PWD?rev=$TARGET#nixosConfigurations.$HOST.config.system.build.toplevel" -o "$TMP_DIR/result-target" |& nom
    fi

    echo ""
    echo "[nix-diff] Configuration Diff for $HOST:"
    nix run nixpkgs#nvd -- diff "$TMP_DIR/result-base" "$TMP_DIR/result-target"

# Deploy a host configuration
deploy-all *args="":
    deploy cetus hercules {{args}}

# Deploy servers hosts configurations
deploy node *args="":
    deploy .#{{node}} {{args}}

