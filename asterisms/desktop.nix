{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Asterism-unspecific stuff
    ./base.nix

    # CLI tools/apps
    ../stars/cli/act.nix
    ../stars/cli/btop.nix
    ../stars/cli/dust.nix
    ../stars/cli/nvim/default.nix
    ../stars/cli/oh-my-posh
    ../stars/cli/onefetch.nix
    ../stars/cli/pfetch.nix
    ../stars/cli/typer.nix
    ../stars/cli/zellij.nix
    ../stars/cli/zsh.nix

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
    ../stars/core/docker.nix
    ../stars/core/email.nix
    ../stars/core/font.nix
    ../stars/core/gh.nix
    ../stars/core/gnupg.nix
    ../stars/core/localsend.nix
    ../stars/core/manual.nix
    ../stars/core/pipewire.nix

    # Dev stuff
    ../stars/dev/c.nix

    # Networking
    ../stars/cli/atac.nix
    ../stars/net/network-manager.nix
    ../stars/net/qbittorrent.nix
    ../stars/net/protonvpn.nix
    ../stars/net/tools.nix

    # Self-hosted servers
    #../stars/srv/ollama.nix
  ];
}
