{inputs, ...}: {
  homeConfig = _: {
    imports = [inputs.schizofox.homeManagerModule];

    programs.schizofox = {
      enable = true;

      security = {
        sanitizeOnShutdown = false;
        sandbox = true;
      };
    };
  };
}
