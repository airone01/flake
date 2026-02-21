_: {
  imports = [
    ./core

    ./profiles/desktop
    ./profiles/development
    ./profiles/gaming.nix
    ./profiles/virt.nix

    ./srv
    ./srv/anubis.nix
    ./srv/gitea.nix
    # ./srv/hercules.nix
    # ./srv/ollama.nix
    ./srv/searchix.nix
    ./srv/ssh-server
    ./srv/traefik.nix
    # ./srv/vaulwarden.nix
  ];
}
