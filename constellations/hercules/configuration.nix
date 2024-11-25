{stars, ...}: {
  networking.hostName = "hercules";
  stars.mainUser = "rack";
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Paris";

  

  imports = with stars; [
    cli-btop
    cli-eza
    cli-oh-my-posh
    cli-zellij
    cli-zsh
    core-docker
    core-font
    core-gh
    core-sops
    core-unfree
    dev-core
    dev-garnix
    r1-git
  ];
}
