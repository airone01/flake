{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    caelestiaPkg = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          sed -i 's/return screens.get(Hypr.focusedMonitor);/let active = screens.get(Hypr.focusedMonitor); if (active) return active; let vals = screens.values(); let first = vals.next(); return first.done ? null : first.value;/' services/Visibilities.qml
          sed -i 's/WlrKeyboardFocus.OnDemand/WlrKeyboardFocus.Exclusive/g' modules/drawers/Drawers.qml
        '';
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
        xdg.configFile."caelestia/shell.json".source = ./shell.json;
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
