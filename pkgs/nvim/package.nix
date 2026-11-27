{
  additionalNvfModules ? [],
  inputs,
  lib,
  pkgs,
  ...
}:
(inputs.nvf.lib.neovimConfiguration
  {
    inherit pkgs;
    modules =
      [(import ./mods/base.nix lib)]
      ++ additionalNvfModules;
  }).neovim
