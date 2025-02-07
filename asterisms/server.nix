{ config, pkgs, ... }: {
  imports = [
    # Asterism-unspecific stuff
    ./base.nix

    # CLI tools/apps
    ../stars/cli/btop.nix
    ../stars/cli/zellij.nix
    ../stars/cli/zsh.nix

    # Core components
    ../stars/core/gh.nix
  ];
}
