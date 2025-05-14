{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix

    # CLI tools/apps
    ../stars/cli/act.nix
    ../stars/cli/btop.nix
    ../stars/cli/dust.nix
    ../stars/cli/nvim/default.nix
    ../stars/cli/oh-my-posh
    ../stars/cli/onefetch.nix
    ../stars/cli/pfetch.nix
    ../stars/cli/typer.nix
    ../stars/cli/zellij.nix
    ../stars/cli/zsh.nix

    # Core components
    ../stars/core/docker.nix
    ../stars/core/gh.nix
    ../stars/core/manual.nix

    # Dev stuff
    ../stars/dev/c.nix

    # Networking
    ../stars/cli/atac.nix
    ../stars/net/tools.nix
  ];
}
