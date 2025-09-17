# More generic desktop preset - used for Ursa Major
_: {
  imports = [
    # CLI tools
    ../stars/dev/tools/all.nix
    ../stars/dev/ide/nvim

    # Shell
    ../stars/sh/zsh.nix
    ../stars/sh/oh-my-posh

    # GUI tools/apps
    ../stars/apps/video-recorder/obs.nix
    ../stars/apps/video-viewer/vlc.nix
    ../stars/apps/web-browser/firefox.nix

    # System
    ../stars/sys/audio/pipewire.nix
    ../stars/sys/net/network-manager.nix

    # DE
    ../stars/de-wm/gnome.nix

    # Virtualization & Docker
    ../stars/virt/qemu.nix

    # Misc
    ../stars/de-wm/font.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
