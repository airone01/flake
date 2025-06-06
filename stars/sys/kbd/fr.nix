{config, ...}: {
  home-manager.users.${config.stars.mainUser}.home.keyboard.layout = "fr";

  console.keyMap = "fr";

  services.xserver.xkb = {
    layout = "fr,us";
  };
}
