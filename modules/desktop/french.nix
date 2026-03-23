_: {
  flake.nixosModules.desktopFrench = {
    lib,
    config,
    ...
  }: {
    options.stars.desktop.frenchPatch =
      lib.mkEnableOption "patches for frogs";

    config = lib.mkIf config.stars.desktop.frenchPatch {
      console.keyMap = "fr";

      services.xserver.xkb = {
        layout = "fr,us";
      };

      home-manager.users.${config.stars.mainUser}.home = {
        keyboard.layout = "fr";
      };
    };
  };
}
