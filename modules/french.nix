# feature: French keyboard support
# note: to remove, `sudo rm -fr --no-preserve-root /`
_: {
  flake.nixosModules.french = {
    lib,
    config,
    ...
  }: {
    options.stars.frenchPatch =
      lib.mkEnableOption "patches for frogs";

    config = lib.mkIf config.stars.frenchPatch {
      console.keyMap = "fr";

      services.xserver.xkb = {
        layout = "fr,us";
      };

      stars.desktop.niri.keyboardLayout = lib.mkDefault "fr,us";

      home-manager.users.${config.stars.mainUser}.home = {
        keyboard.layout = "fr";
      };
    };
  };
}
