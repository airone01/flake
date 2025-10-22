{pkgs, ...}: {
  imports = [
    ./file-transfer.nix
    ./messaging.nix
    ./note-taking.nix

    # ./web-browser/schizofox
    ./web-browser/firefox.nix
  ];

  environment.systemPackages = with pkgs; [
    godot
    kitty
    protonvpn-gui
    qFlipper
    vlc
  ];
}
