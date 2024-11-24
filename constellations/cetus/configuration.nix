{stars, ...}: {
  networking.hostName = "cetus";
  stars.mainUser = "rack";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  imports = with stars; [
    cli-btop
    cli-eza
    cli-oh-my-posh
    cli-zellij
    cli-zsh
    core-sops
    dev-core
    dev-garnix
    r1-git
  ];
}
