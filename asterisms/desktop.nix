# My usual personal desktop preset
_: {
  imports = [
    ./desktop-cli.nix
    ./specific.nix

    # GUI tools/apps
    ../modules/apps/all.nix

    # System
    ../modules/sys/audio/pipewire.nix
    ../modules/sys/net/network-manager.nix

    # Secrets
    ../modules/sys/secret/gnupg.nix

    # DE
    ../modules/de-wm/gnome.nix

    # Virtualization & Docker
    ../modules/virt/docker.nix
    ../modules/virt/qemu.nix

    # Misc
    ../modules/de-wm/font.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
