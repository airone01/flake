{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./desktop-cli.nix

    # GUI tools/apps
    ../stars/gui/arduino.nix
    ../stars/gui/cursor.nix
    ../stars/gui/discord.nix
    ../stars/gui/firefox.nix
    ../stars/gui/gnome.nix
    ../stars/gui/kitty.nix
    ../stars/gui/obsidian.nix
    ../stars/gui/qFlipper.nix
    ../stars/gui/steam.nix
    ../stars/gui/thunderbird.nix

    # Core components
    ../stars/core/email.nix
    ../stars/core/font.nix
    ../stars/core/gnupg.nix
    ../stars/core/localsend.nix
    ../stars/core/pipewire.nix

    # Networking
    ../stars/net/network-manager.nix
    ../stars/net/qbittorrent.nix
    ../stars/net/protonvpn.nix
  ];
}
