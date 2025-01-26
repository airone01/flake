{stars, ...}: {
  imports = with stars; [
    # Asterism-unspecific stuff
    ./base.nix

    # CLI tools/apps
    cli-btop
    cli-eza
    cli-nvim
    cli-oh-my-posh
    cli-zellij
    cli-zsh

    # GUI tools/apps
    gui-cursor
    gui-discord
    gui-gnome
    gui-kitty
    gui-firefox
    gui-steam

    # Core components
    core-docker
    core-font
    core-gh
    core-gnupg
    core-pipewire

    # Networking
    net-network-manager

    #dev-rust # TODO: Move to direnv
  ];
}
