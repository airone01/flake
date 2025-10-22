# My usual personal desktop preset
_: {
  imports = [
    ./desktop-cli.nix
    ./specific.nix

    # GUI tools/apps
    ../stars/apps/all.nix

    # System
    ../stars/sys/audio/pipewire.nix
    ../stars/sys/net/network-manager.nix

    # Secrets
    ../stars/sys/secret/gnupg.nix

    # DE
    ../stars/de-wm/gnome.nix

    # Virtualization & Docker
    ../stars/virt/docker.nix
    ../stars/virt/qemu.nix

    # Misc
    ../stars/de-wm/font.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
