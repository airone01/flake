# airone01/flake

A modular and extensible NixOS configuration system using a custom star-based architecture. This repository contains my personal NixOS configurations for multiple machines and deployments.

## 📚 Table of Contents

- [Structure](#structure)
- [Getting Started](#getting-started)
- [Architecture](#architecture)
- [Contributing](#contributing)
- [Roadmap](#roadmap)

## 🏗️ Structure

```
.
├── asterisms/        # High-level configuration combinations
├── constellations/   # Machine-specific configurations
│   ├── aquarius/    # Server configuration
│   ├── cassiopeia/  # Desktop configuration
│   └── ursamajor/   # ISO configuration
├── lib/             # Helper functions and core modules
├── rockets/         # Development shells
├── secrets/         # Encrypted secrets (using sops-nix)
└── stars/           # Modular configuration units
```

### Key Components

- **Stars**: Individual configuration modules that can be composed together
- **Asterisms**: Predefined combinations of stars for specific use cases
- **Constellations**: Complete system configurations for specific machines
- **Rockets**: Development environments for specific tasks
- **Secrets**: Encrypted configuration secrets managed with sops-nix

## 🚀 Getting Started

### Prerequisites

- NixOS or Nix with flakes enabled
- Git
- (Optional) sops for secret management

### Installation

1. Clone the repository:
```bash
git clone https://github.com/airone01/dotfiles2 ~/.config/nixos
```

2. Review and modify the configuration:
   - Choose or create a constellation in `constellations/`
   - Modify `flake.nix` to include your system
   - Adjust hardware configuration as needed

3. Deploy the configuration:
```bash
# For an existing system
nixos-rebuild switch --flake .#hostname

# For a new installation
nixos-install --flake .#hostname
```

### Development Environment

The repository includes development shells for various tasks:

```bash
# For commit message linting
nix develop .#commitlint

# For Tauri development
nix develop .#tauri
```

## 🏛️ Architecture

### The Star System

Stars are the fundamental building blocks of this configuration. Each star is a self-contained NixOS module that can be composed with others.

```nix
# Example star structure
stars/
├── gui/             # GUI-related configurations
│   ├── gnome.nix
│   └── hyprland.nix
├── cli/             # CLI tool configurations
│   └── nvim/
└── core/            # Core system configurations
    └── sound.nix
```

### Flake Structure

The `flake.nix` provides:

- **nixosConfigurations**: System configurations for each machine
- **packages**: Installable packages and ISO images
- **devShells**: Development environments

### Secret Management

Secrets are managed using sops-nix with age encryption:

- Secrets are stored in `secrets/`
- Keys are configured in `.sops.yaml`
- Each constellation can access only its required secrets

## 🤝 Contributing

This is my flake and it's mainly personal but contributions are welcome if you have spare time. Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run the following checks:
   ```bash
   # Format code
   nix fmt

   # Verify builds
   nix flake check
   ```
5. Commit your changes (following commitlint conventions)
6. Push to your branch
7. Open a Pull Request

### Commit Message Convention

This repository uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). Each commit message should be structured as:

```
type(scope): description

[optional body]
[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
Scopes: See `.commitlintrc.yml` for valid scopes

## 📋 Roadmap

| Category | Task | Priority | Status |
|----------|------|----------|--------|
| Documentation | Add installation guides for each constellation | High | 🟡 Pending |
| Documentation | Add architecture diagrams | Medium | 🔴 Not Started |
| Documentation | Create contribution guidelines | Medium | 🔴 Not Started |
| Testing | Add GitHub Actions workflows | High | 🔴 Not Started |
| Testing | Implement basic system tests | Medium | 🔴 Not Started |
| Testing | Add Nix formatting checks | High | 🔴 Not Started |
| Security | Implement firewall configuration | High | 🔴 Not Started |
| Security | Add fail2ban configuration | Medium | 🔴 Not Started |
| Security | Configure automatic security updates | High | 🔴 Not Started |
| Security | Implement SSH hardening | High | 🔴 Not Started |
| Backup | Add restic/borgbackup configuration | High | 🔴 Not Started |
| Monitoring | Set up Prometheus + Grafana | Medium | 🔴 Not Started |
| Updates | Configure automatic system updates | Medium | 🔴 Not Started |
| Infrastructure | Add Hydra instance | Low | 🔴 Not Started |
| Infrastructure | Add TeamCity instance | Low | 🔴 Not Started |
| Infrastructure | Add Attic binary cache | Medium | 🔴 Not Started |
| Infrastructure | Add Mastodon instance | Low | 🔴 Not Started |
| Infrastructure | Add Matrix instance | Low | 🔴 Not Started |
| Infrastructure | Add Lemmy instance | Low | 🔴 Not Started |
| Infrastructure | Add Invidious instance | Low | 🔴 Not Started |
| Infrastructure | Add SearXNG instance | Medium | 🔴 Not Started |
| Infrastructure | Add Gitea instance | Medium | 🔴 Not Started |
| Infrastructure | Add Jellyfin instance | Low | 🔴 Not Started |
| Infrastructure | Add Vaultwarden instance | Low | 🔴 Not Started |
| Infrastructure | Add Home Assistant instance | Low | 🔴 Not Started |
| Infrastructure | Add Paperless-ngx instance | Low | 🔴 Not Started |
| Infrastructure | Add Syncthing instance | Low | 🔴 Not Started |
| Infrastructure | Add Calibre-Web instance | Low | 🔴 Not Started |
| Infrastructure | Add Photoprism instance | Low | 🔴 Not Started |
| Architecture | Figuring all of this out | High | 🟣 Always going on |


Legend:
- 🟢 Complete
- 🟡 In Progress/Partial
- 🔴 Not Started
- 🟣 Special

## 🔧 Tooling

### Available Development Shells

- `commitlint`: For commit message linting
- `tauri`: For Tauri application development (I use it for JS/TS as well)

### Useful Commands

```bash
# Rebuild the current system
./rebuild.sh <hostname>

# Build an ISO image
nix build .#ursamajor-install-iso

# Enter development shell
nix develop .#<shell-name>
```

## 📦 Machines

### aquarius
- Purpose: Home server
- Services: Caddy, planned hosting for various services
- Status: Active

### cassiopeia
- Purpose: Desktop workstation
- Features: GNOME desktop, development tools
- Status: Active

### ursamajor
- Purpose: Installation ISO
- Features: Basic system for testing and installation
- Status: In Development

## 📄 License

This project is open source and available under the Apache v2 license.

## 🙏 Acknowledgments

- [NixOS](https://nixos.org/) for the amazing Linux distribution
- All the fantastic Nix community members who share their configurations
- NotAShelf for inspiration
- Contributors to all the tools and packages used in this configuration
