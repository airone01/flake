{pkgs, ...}: {
  # Not bothering to use the flake: compiling lix takes fucking forever, my laptop is not a beast
  # https://lix.systems/add-to-config/
  nix.package = pkgs.lix;
}
