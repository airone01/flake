_: {
  # https://git.sr.ht/~alanpearce/searchix/tree/b7de525d7fe617674030c493ec4214f2f5a4b887
  services.searchix = {
    enable = true;
    settings = {
      web = {
        port = 51313;
        listenAddress = "localhost";
        baseURL = "http://localhost:51313";
      };
    };
  };
}
