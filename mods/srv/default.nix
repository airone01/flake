# shortcut module to avoid duplicating those imports in all server hosts
{
  imports = [
    ./anubis.nix
    ./gitea.nix
    ./hercules-ci.nix
    ./mcheads.nix
    ./ollama.nix
    ./searchix.nix
    ./ssh.nix
    ./traefik.nix
    ./vaultwarden.nix
    ./website.nix
    ./wireguard.nix
  ];
}
