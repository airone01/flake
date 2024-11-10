_: {
  homeConfig = _: {
    home.keyboard.layout = "fr";
  };

  config = _: {
    console.keyMap = "fr";

    services.xserver.xkb = {
      layout = "fr,us";
    };
  };
}
