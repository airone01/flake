{self, ...}: {
  perSystem = {pkgs, ...}: {
    # Default version for the flake packages, NixOS module will create a
    # customized one.
    packages.myNoctalia = self.inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      inherit
        (builtins.fromJSON (builtins.readFile ./noctalia.json))
        settings
        ;
    };
  };

  flake.nixosModules.noctalia = {
    lib,
    pkgs,
    config,
    ...
  }: let
    username = config.stars.mainUser;
    homeDir = "/home/${username}";

    # Patch hardcoded `/home/r1` path
    rawSettings = builtins.readFile ./noctalia.json;
    patchedSettings = builtins.fromJSON (builtins.replaceStrings ["/home/r1"] [homeDir] rawSettings);

    noctaliaCustom = self.inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      inherit (patchedSettings) settings;
    };
  in {
    options.stars.desktop.noctalia.enable = lib.mkEnableOption "Noctalia Shell";

    config = lib.mkIf config.stars.desktop.noctalia.enable {
      environment.systemPackages = [
        noctaliaCustom
      ];
    };
  };
}
