{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    caelestiaPkg = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          ln -s $out/bin/caelestia-shell $out/bin/caelestia
        '';
    });
  in {
    packages.caelestia = caelestiaPkg;
  };

  flake.nixosModules.caelestia = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.desktop.caelestia.enable = lib.mkEnableOption "Caelestia Shell";

    config = lib.mkIf config.stars.desktop.caelestia.enable {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.caelestia
      ];

      home-manager.users.${config.stars.mainUser} = {
        xdg.configFile."niri_caelestia/shell.json".source = ./shell.json;
      };

      services.greetd = lib.mkIf (config.services.greetd.enable && config.stars.desktop.niri.enable) {
        settings = {
          default_session = {
            command = lib.mkForce "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd niri-session";
          };
        };
      };
    };
  };
}
