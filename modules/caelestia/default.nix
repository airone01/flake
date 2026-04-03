{
  self,
  inputs,
  ...
}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }:
    lib.mkIf (pkgs.stdenv.hostPlatform.system != "aarch64-linux") {
      packages.caelestia =
        (inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          withCli = true;
        }).overrideAttrs (old: {
          postInstall =
            (old.postInstall or "")
            + ''
              ln -s $out/bin/caelestia-shell $out/bin/caelestia
            '';
        });
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

        home.file.".face".source = pkgs.fetchurl {
          url = "https://github.com/airone01.png";
          sha256 = "1w7cznj7cx55a6zk6yz1qks0psjh8wgh2nj0qhqqvzq1bd2w6r8j";
        };
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
