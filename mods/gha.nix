# feature: GitHub Actions automatic build
# This also merges the `packages` checks with checks to build my NixOS configs
{
  self,
  inputs,
  lib,
  ...
}: let
  nixosChecks = lib.foldl' (
    acc: name: let
      host = self.nixosConfigurations.${name};
      sys = host.pkgs.stdenv.hostPlatform.system;
    in
      lib.recursiveUpdate acc {
        ${sys}.${name} = host.config.system.build.toplevel;
      }
  ) {} (builtins.attrNames (self.nixosConfigurations or {}));
in {
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.recursiveUpdate self.packages nixosChecks;
  };
}
