{ config, pkgs, ... }:
let
  stars = import ../stars { inherit config pkgs; };
in {
  imports = with stars; [
    # Asterism-unspecific stuff
    ./base.nix

    # CLI tools/apps
    cli-btop
    cli-eza
    cli-zellij
    cli-zsh

    # Core components
    core-gh
  ];
}
