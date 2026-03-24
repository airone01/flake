# shortcut module to avoid duplicating those imports in all server hosts
{self, ...}: {
  flake.nixosModules.server-services = {
    imports = [
      self.nixosModules.anubis
      self.nixosModules.gitea
      self.nixosModules.hercules-ci
      self.nixosModules.mcheads
      self.nixosModules.ollama
      self.nixosModules.searchix
      self.nixosModules.ssh
      self.nixosModules.traefik
      self.nixosModules.vaultwarden
    ];
  };
}
