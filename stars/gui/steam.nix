_: {
  name = "steam";

  config = _: {
    programs.steam.enable = true;
    programs.gamemode.enable = true;
  };
}
