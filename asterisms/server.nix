{stars, ...}: {
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
