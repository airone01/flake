{
  pkgs,
  stars,
  config,
  ...
}: {
  networking.hostName = "cassiopeia";
  stars.mainUser = "r1";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  imports = with stars; [
    boot-plymouth
    cli-btop
    cli-eza
    cli-nvim
    cli-oh-my-posh
    cli-zellij
    cli-zsh
    core-docker
    core-font
    core-gh
    core-pipewire
    core-sops
    core-unfree
    dev-core
    dev-garnix
    dev-rust
    gui-cursor # cannot allow unfree since pkgs is passed to NixOS, hence not available yet.
    #   See https://discourse.nixos.org/t/allowunfree-doesnt-work-with-flake-managed-system/21798/4
    #   See https://github.com/NixOS/nixpkgs/issues/191910
    gui-gnome
    gui-kitty
    gui-firefox
    #gui-schizofox
    gui-steam
    hard-graphics
    hard-nvidia
    kbd-fr
    net-network-manager
    r1-git
  ];

  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [mullvad-vpn];
  services.mullvad-vpn.enable = true;
}
