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

## Packages

Some of the more interesting packages exposed in this flake are:

- `mek-fonts`/*: Some fonts by [MEK.txt](https://mektxt.com/)
- `noctalia`: my DE config
- `nvim` & `nvim-full`: light and full versions of my NeoVim configuration. Uses
  [nvf](https://github.com/NotAShelf/nvf).
- `wallpapers`: wallpapers I like

## Organization

The directory are organized roughly as followed:

- `hosts/`: hosts configurations
- `mods/`: configurations shared across hosts
- `common/`: shared configurations shortcuts
- `pkgs/`: half source-code, half nix derivations of small apps and scripts
- `misc/`: some files used by outside programs
- `secrets/`: sops-nix encrypted secrets

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

## License

This project is open source and available under the [MIT License](/LICENSE).

## Acknowledgments

- [nixpkgs contributors](https://github.com/NixOS/nixpkgs/graphs/contributors)
  pour les travaux
- All the fantastic Nix community members who share their configurations
- Contributors to all the tools and packages used in this configuration
- See the "Sites I Like" section in [my blog](https://air1.one/about) for more
  amazing peeps
