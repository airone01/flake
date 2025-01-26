_: {
  config = _: {
    programs.gnupg.agent = {
       enable = true;
       enableSSHSupport = true;
    };
  };
}
