# More generic desktop preset - used for Ursa Major
_: {
  imports = [
    # CLI tools
    ../modules/dev/tools/all.nix
    ../modules/dev/ide/nvim

    # Shell
    ../modules/sh/zsh.nix
    ../modules/sh/oh-my-posh

    # GUI tools/apps
    ../modules/apps/video-recorder/obs.nix
    ../modules/apps/video-viewer/vlc.nix
    ../modules/apps/web-browser/firefox.nix

    # System
    ../modules/sys/audio/pipewire.nix
    ../modules/sys/net/network-manager.nix

    # DE
    ../modules/de-wm/gnome.nix

    # Virtualization & Docker
    ../modules/virt/qemu.nix

    # Misc
    ../modules/de-wm/font.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
