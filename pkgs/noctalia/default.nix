{
  pkgs,
  inputs,
  mainUser ? "r1",
  ...
}: let
  homeDir = "/home/${mainUser}";
  rawSettings = builtins.readFile ./noctalia.json;
  # Patch hardcoded `/home/r1` path
  patchedSettings = builtins.fromJSON (builtins.replaceStrings ["/home/r1"] [homeDir] rawSettings);
in
  inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
    inherit pkgs;
    inherit (patchedSettings) settings;
  }
