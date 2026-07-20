# feature: GitHub Actions automatic build
{
  self,
  inputs,
  ...
}: {
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {checks = self.packages;};
}
