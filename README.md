<h1 align="center">
  airone01/flake
</h2>

<h4 align="center">
  <a href="https://profile.intra.42.fr/users/elagouch"><img alt="School 42 badge" src="https://img.shields.io/badge/-elagouch-0?style=flat-square&labelColor=020617&color=5a45fe&logo=42"></a>
  <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-ef00c7?style=flat-square&logo=creativecommons&logoColor=fff&labelColor=020617">
  <img alt="Made with Nix" src="https://img.shields.io/badge/Made_with-Nix-ff2b89?style=flat-square&logo=nixos&logoColor=fff&labelColor=020617">
  <img alt="Release version" src="https://img.shields.io/github/v/release/airone01/flake?style=flat-square&logo=nixos&logoColor=fff&label=Release&labelColor=020617&color=ff8059">
  <img alt="GitHub contributors" src="https://img.shields.io/github/contributors-anon/airone01/flake?style=flat-square&logo=github&labelColor=020617&color=ffc248&label=Contributors">
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
[dendritic pattern](https://github.com/mightyiam/dendritic) strictly. For this
reason, all modules and features are dropped into the `modules` directory, and
loosely grouped by category.

Notable stuff `modules/` include:

- `hosts/`: NixOS configurations for hosts
- `pkgs/`: half source-code, half nix derivations of small apps and scripts
- `shells/`: devShells
- `desktop/`: options for desktops
- `srv/`: options for servers
- `core.nix`: default config I want everywhere
- `dev.nix`: dev config I want (almost) everywhere
- `formatting.nix`: linting and formatting with treefmt and git hooks
- `gaming.nix`: options for gaming
- `nvim.nix`: Neovim config using [NVF](https://github.com/NotAShelf/nvf/)

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
