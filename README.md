<h1 align="center">
  airone01/flake
</h2>

<h4 align="center">
  <a href="https://profile.intra.42.fr/users/elagouch"><img alt="School 42 badge" src="https://img.shields.io/badge/-elagouch-020617?style=flat-square&labelColor=020617&color=5a45fe&logo=42"></a>
  <img alt="Apache-2.0 license" src="https://img.shields.io/badge/License-Apache--2.0-ef00c7?style=flat-square&logo=creativecommons&logoColor=fff&labelColor=020617">
  <img alt="Made with Nix" src="https://img.shields.io/badge/Made_with-Nix-ff2b89?style=flat-square&logo=nixos&logoColor=fff&labelColor=020617">
  <img alt="Release version" src="https://img.shields.io/github/v/release/airone01/flake?style=flat-square&logo=nixos&logoColor=fff&label=Release&labelColor=020617&color=ff8059">
  <img alt="GitHub contributors" src="https://img.shields.io/github/contributors-anon/airone01/flake?style=flat-square&logo=github&labelColor=020617&color=ffc248&label=Contributors">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/airone01/flake?style=flat-square&logo=github&labelColor=020617&color=f9f871&label=Last%20commit">
</h4>

This repository contains my personal NixOS configurations for multiple machines
and deployments. It's very faulty to say the least, but I love it.

## Key Components

- **Stars**: Individual configuration parts. Can vary from a HM config to a list
  of packages
- **Asterisms**: Predefined combinations of stars for specific use cases
- **Constellations**: Complete system configurations for specific machines
- **Rockets**: Development environments for specific tasks
- **Secrets**: Encrypted configuration secrets managed with sops-nix

## Machines

| **Name**   | **Purpose** | **Status** |
| ---------- | ----------- | ---------- |
| aquarius   |             | Abandoned  |
| cassiopeia | Laptop      | Active     |
| cetus      | Homelab     | Active     |
| ursamajor  |             | Abandoned  |

### Commit Message Convention

This repository uses
[conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). See
[`.commitlintrc.yml`](.commitlintrc.yml) for the config.

## License

This project is open source and available under the
[Apache v2 license](/LICENSE).

## Acknowledgments

- [NixOS](https://nixos.org/) for the amazing Linux distribution
- All the fantastic Nix community members who share their configurations
- [NotAShelf](https://github.com/NotAShelf) for inspiration
- Contributors to all the tools and packages used in this configuration
