{
  boot = {
    initrd.systemd.enable = true;
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
