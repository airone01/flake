<h1 align="center">
  airone01/flake
</h2>

<h4 align="center">
  <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-5a45fe?style=flat-square&logo=creativecommons&logoColor=fff&labelColor=020617">
  <img alt="Made with Nix" src="https://img.shields.io/badge/Made_with-Nix-d049d7?style=flat-square&logo=nixos&logoColor=fff&labelColor=020617">
  <img alt="Release version" src="https://img.shields.io/github/v/release/airone01/flake?style=flat-square&logo=nixos&logoColor=fff&label=Release&labelColor=020617&color=ff758b">
  <img alt="GitHub contributors" src="https://img.shields.io/github/contributors-anon/airone01/flake?style=flat-square&logo=github&labelColor=020617&color=ffb971&label=Contributors">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/airone01/flake?style=flat-square&logo=github&labelColor=020617&color=f9f871&label=Last%20commit">
</h4>

This repository contains my personal NixOS configurations for multiple machines
and deployments. It's very faulty to say the least, but I love it.

> [!IMPORTANT]
> This repo is opinionated, modules and derivations are tailored for my use. If
> I ever define something and I decide to share it, I will update this note
> accordingly and explain usage in this README, but for now, there is not much
> for you I'm afraid. Nothing is stopping you from yoinking code however, the
> repo is MIT licensed!

## Organization

This repository is now trying to follow the
[dendritic pattern](https://github.com/mightyiam/dendritic). For this reason,
all modules and features are dropped into the `modules` directory.

Notable stuff `modules/` include:

- `hosts/`: hosts configurations
- `pkgs/`: half source-code, half nix derivations of small apps and scripts
- `srv/`: services configurations
- `*.nix`: any feature detailed at the top of the file

## Machines

| **Name**   | **Purpose** | **Status** |
| ---------- | ----------- | ---------- |
| cassiopeia | Laptop      | Active     |
| cetus      | Homelab     | Active     |
| hercules   | VPS         | Active     |
| lyra       | Main PC     | Active     |
| aquarius   |             | Abandoned  |
| cygnus     |             | Abandoned  |
| ursamajor  |             | Abandoned  |

### Commit Message Convention

This repository uses
[conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).
Configured at [`.commitlintrc.yml`](.commitlintrc.yml).

## License

This project is open source and available under the [MIT License](/LICENSE).

## Acknowledgments

- [nixpkgs contributors](https://github.com/NixOS/nixpkgs/graphs/contributors)
  pour les travaux
- All the fantastic Nix community members who share their configurations
- Contributors to all the tools and packages used in this configuration
- See the "Sites I Like" section in [my blog](https://air1.one/about) for more
  amazing peeps
