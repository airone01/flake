{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages.myNoctalia = self.inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      # settings =
      #   (builtins.fromJSON
      #     (builtins.readFile ./noctalia.json)).settings;
    };
  };

  flake.nixosModules.noctalia = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.desktop.noctalia.enable = lib.mkEnableOption "Noctalia Shell";

    config = lib.mkIf config.stars.desktop.noctalia.enable {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia
      ];
    };
  };
}
