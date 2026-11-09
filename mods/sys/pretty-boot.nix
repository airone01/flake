{
  boot = {
    kernelParams = [
      "quiet"
      "plymouth.use-simpledrm"
    ];
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
  };
}
