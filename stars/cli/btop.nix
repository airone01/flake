_: {
  name = "btop";

  homeConfig = _: {
    programs.btop = {
      enable = true;

      settings = {
        color_theme = "horizon";
        update_ms = 200;
      };
    };
  };
}
