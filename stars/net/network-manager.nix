_: {
  name = "networkmanager";

  config = _: {
    networking = {
      networkmanager = {
        enable = true;
      };
    };
  };
}
