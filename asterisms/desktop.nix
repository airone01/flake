{ config, pkgs, ... }: {
  imports = [
    # Asterism-unspecific stuff
    ./base.nix

    # CLI tools/apps
    ../stars/cli/act.nix
    ../stars/cli/atac.nix
    ../stars/cli/btop.nix
    ../stars/cli/nvim/default.nix
    ../stars/cli/oh-my-posh
    ../stars/cli/zellij.nix
    ../stars/cli/zsh.nix

    # GUI tools/apps
    ../stars/gui/cursor.nix
    ../stars/gui/discord.nix
    ../stars/gui/firefox.nix
    ../stars/gui/gnome.nix
    ../stars/gui/kitty.nix
    ../stars/gui/qFlipper.nix
    ../stars/gui/steam.nix

    # Core components
    ../stars/core/docker.nix
    ../stars/core/font.nix
    ../stars/core/gh.nix
    ../stars/core/gnupg.nix
    ../stars/core/pipewire.nix

    # Networking
    ../stars/net/network-manager.nix
  ];

}
