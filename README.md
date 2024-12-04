# airone01/flake

A modular and extensible NixOS configuration system using a custom star-based architecture. This repository contains my personal NixOS configurations for multiple machines and deployments, managed with a comprehensive task runner.

## 📚 Table of Contents

- [Features](#features)
- [Structure](#structure)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Architecture](#architecture)
- [Contributing](#contributing)
- [Roadmap](#roadmap)

## ✨ Features

- 🌟 Modular "star" system for composable configurations
- 🛠️ Comprehensive task runner using Just
- 🔒 Secret management with sops-nix
- 🚀 Development shells for various tasks
- 📦 Multiple machine configurations
- 🔄 Automated formatting and checks
- 💾 ISO generation capabilities
- 📁 Direnv support

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
- `just` command runner
- (Optional) sops for secret management

### Installation

1. Install the `just` command runner:

```bash
nix-env -iA nixpkgs.just
```

2. Bootstrap a new system:

```bash
just bootstrap <hostname>
```

This will:

- Set up the nix channels
- Install required tools
- Clone the repository
- Prepare the system for configuration

3. Generate SOPS key (if using secrets):

```bash
just sops-key
```

4. Review and modify the configuration:

   - Choose or create a constellation in `constellations/`
   - Modify `flake.nix` to include your system
   - Adjust hardware configuration as needed

5. Deploy the configuration:

```bash
just switch <hostname>
```

## 🛠️ Usage

### System Management

```bash
# Build and switch to configuration
just switch <hostname>

# Test configuration without applying
just test <hostname>

# Build ISO image
just iso [system] [format]

# Clean old generations
just clean [days]
```

### Development Tasks

```bash
# Format nix files
just fmt

# Check formatting
just fmt-check

# Run flake checks
just check

# Enter development shell
just develop [shell-name]

# Show changes to nix files
just show-diff
```

### Update Management

```bash
# Update all flake inputs
just update

# Update specific input
just update-input <input-name>
```

### Available Development Shells

- `commitlint`: For commit message linting
- `tauri`: For Tauri application development (JS/TS support included)

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
- Generate keys with `just sops-key`

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

## 🤝 Contributing

This is my flake and it's mainly personal but contributions are welcome if you have spare time. Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run the following checks:

   ```bash
   # Format code
   just fmt

   # Verify builds
   just check
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

| Category       | Task                                           | Priority | Status             |
| -------------- | ---------------------------------------------- | -------- | ------------------ |
| Documentation  | Add installation guides for each constellation | High     | 🟡 Pending         |
| Documentation  | Add architecture diagrams                      | Medium   | 🔴 Not Started     |
| Documentation  | Create contribution guidelines                 | Medium   | 🔴 Not Started     |
| Testing        | Add GitHub Actions workflows                   | High     | 🔴 Not Started     |
| Testing        | Implement basic system tests                   | Medium   | 🔴 Not Started     |
| Testing        | Add Nix formatting checks                      | High     | 🟢 Complete        |
| Security       | Implement firewall configuration               | High     | 🔴 Not Started     |
| Security       | Add fail2ban configuration                     | Medium   | 🔴 Not Started     |
| Security       | Configure automatic security updates           | High     | 🔴 Not Started     |
| Security       | Implement SSH hardening                        | High     | 🔴 Not Started     |
| Backup         | Add restic/borgbackup configuration            | High     | 🔴 Not Started     |
| Monitoring     | Set up Prometheus + Grafana                    | Medium   | 🔴 Not Started     |
| Updates        | Configure automatic system updates             | Medium   | 🔴 Not Started     |
| Infrastructure | Add Hydra instance                             | Low      | 🟢 Complete        |
| Infrastructure | Add TeamCity instance                          | Low      | 🔴 Not Started     |
| Infrastructure | Add Attic binary cache                         | Medium   | 🔴 Not Started     |
| Infrastructure | Add Mastodon instance                          | Low      | 🟢 Complete        |
| Infrastructure | Add Matrix instance                            | Low      | 🟢 Complete        |
| Infrastructure | Add Lemmy instance                             | Low      | 🔴 Not Started     |
| Infrastructure | Add Invidious instance                         | Low      | 🔴 Not Started     |
| Infrastructure | Add SearXNG instance                           | Medium   | 🔴 Not Started     |
| Infrastructure | Add Gitea instance                             | Medium   | 🟢 Complete        |
| Infrastructure | Add Jellyfin instance                          | Low      | 🔴 Not Started     |
| Infrastructure | Add Vaultwarden instance                       | Low      | 🔴 Not Started     |
| Infrastructure | Add Home Assistant instance                    | Low      | 🔴 Not Started     |
| Infrastructure | Add Paperless-ngx instance                     | Low      | 🔴 Not Started     |
| Infrastructure | Add Syncthing instance                         | Low      | 🔴 Not Started     |
| Infrastructure | Add Calibre-Web instance                       | Low      | 🔴 Not Started     |
| Infrastructure | Add Photoprism instance                        | Low      | 🔴 Not Started     |
| Architecture   | Task runner implementation                     | High     | 🟢 Complete        |
| Architecture   | Figuring all of this out                       | High     | 🟣 Always going on |

Legend:

- 🟢 Complete
- 🟡 In Progress/Partial
- 🔴 Not Started
- 🟣 Special

## 📄 License

This project is open source and available under the Apache v2 license.

## 🙏 Acknowledgments

- [NixOS](https://nixos.org/) for the amazing Linux distribution
- All the fantastic Nix community members who share their configurations
- [NotAShelf](https://github.com/NotAShelf) for inspiration
- [casey/just](https://github.com/casey/just) for the fantastic command runner
- Contributors to all the tools and packages used in this configuration
